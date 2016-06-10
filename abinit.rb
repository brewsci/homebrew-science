class Abinit < Formula
  desc "Atomic-scale first-principles simulation software"
  homepage "http://www.abinit.org"
  url "http://ftp.abinit.org/abinit-8.0.7.tar.gz"
  sha256 "9df2fe572af39cef937a4134d569321b99c6670f187edbac9b355ff2defd5afc"
  revision 1

  bottle do
    cellar :any
    sha256 "820d0f4bf0b9e64dec6c8ef3f4e4ad12c5caf448f880834bfb4cef2891098453" => :el_capitan
    sha256 "c929dcbf0b62f6b8a4a0edc255204df42df39a7dc61309c82bbaae1ad4b7563d" => :yosemite
    sha256 "9184e1d02eba8e1e69cab992cd2a5a9cb0d758b1b3b70368b55d74682c902085" => :mavericks
  end

  option "without-test", "Skip build-time tests (not recommended)"
  option "with-testsuite", "Run full test suite (time consuming)"

  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran
  depends_on "veclibfort"
  depends_on "scalapack" => :recommended
  depends_on "fftw" => ["with-mpi", "with-fortran", :recommended]
  depends_on "libxc" => :recommended
  depends_on "netcdf" => ["with-fortran", :recommended]
  depends_on "etsf_io" => :recommended
  depends_on "gsl" => :recommended

  def install
    # Environment variables CC, CXX, etc. will be ignored.
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "F77"
    ENV.delete "FC"
    args = %W[CC=#{ENV["MPICC"]}
              CXX=#{ENV["MPICXX"]}
              F77=#{ENV["MPIF77"]}
              FC=#{ENV["MPIFC"]}
              --prefix=#{prefix}
              --enable-mpi=yes
              --with-mpi-prefix=#{HOMEBREW_PREFIX}
              --enable-optim=safe
              --enable-openmp=no
              --enable-gw-dpc]

    dft_flavor = "none"
    trio_flavor = "none"

    if build.with? "scalapack"
      args << "--with-linalg-flavor=custom+scalapack"
      args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort -L#{Formula["scalapack"].opt_lib} -lscalapack"
    else
      args << "--with-linalg-flavor=custom"
      args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    end

    if build.with? "etsf_io"
      raise "Building with etsf_io support requires netcdf" if build.without? "netcdf"
      trio_flavor = "netcdf+etsf_io"
      args << "--with-etsf-io-incs=-I#{Formula["etsf_io"].opt_include}"
      args << "--with-etsf-io-libs=-L#{Formula["etsf_io"].opt_lib} -letsf_io_low_level -letsf_io_utils -letsf_io"
      args << "--with-netcdf-incs=-I#{Formula["netcdf"].opt_include}"
      args << "--with-netcdf-libs=-L#{Formula["netcdf"].opt_lib} -lnetcdff -lnetcdf"
    elsif build.with? "netcdf"
      trio_flavor = "netcdf"
      args << "--with-netcdf-incs=-I#{Formula["netcdf"].opt_include}"
      args << "--with-netcdf-libs=-L#{Formula["netcdf"].opt_lib} -lnetcdff -lnetcdf"
    end

    if build.with? "gsl"
      args << "--with-math-flavor=gsl"
      args << "--with-math-incs=-I#{Formula["gsl"].opt_include}"
      args << "--with-math-libs=-L#{Formula["gsl"].opt_lib} -lgsl"
    end

    if build.with? "libxc"
      dft_flavor = "libxc"
      args << "--with-libxc-incs=-I#{Formula["libxc"].opt_include}"
      args << "--with-libxc-libs=-L#{Formula["libxc"].opt_lib} -lxc -lxcf90"
    end

    # need to link against single precision as well, see https://trac.macports.org/ticket/45617 and http://forum.abinit.org/viewtopic.php?f=3&t=2631
    if build.with? "fftw"
      args << "--with-fft-flavor=fftw3"
      args << "--with-fft-incs=-I#{Formula["fftw"].opt_include}"
      args << "--with-fft-libs=-L#{Formula["fftw"].opt_lib} -lfftw3 -lfftw3f -lfftw3_mpi -lfftw3f_mpi"
    end

    args << "--with-dft-flavor=#{dft_flavor}"
    args << "--with-trio-flavor=#{trio_flavor}"

    system "./configure", *args
    system "make"

    if build.with? "test"
      cd "tests"
      if build.with? "testsuite"
        system "./runtests.py 2>&1 | tee make-check.log"
      else
        system "./runtests.py built-in fast 2>&1 | tee make-check.log"
      end
      ohai `grep ", succeeded:" "make-check.log"`.chomp
      prefix.install "make-check.log"
      cd ".."
    end

    system "make", "install"
  end

  test do
    system "#{bin}/abinit", "-b"
  end
end
