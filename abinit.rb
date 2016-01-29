class Abinit < Formula
  desc "Atomic-scale first-principles simulation software"
  homepage "http://www.abinit.org"
  url "http://ftp.abinit.org/abinit-7.10.5.tar.gz"
  sha256 "e9376a3e34790bce90992f28e5fa8554b51ba467bf5709c7fd25d300e7c4f56a"

  bottle do
    cellar :any
    sha256 "8a2038a8b58b020cb5c7cdbcda7217477a2f4cda4601166aaf83323a9ba1abb7" => :el_capitan
    sha256 "f8aefef831a3a767e697fdb0cd50db3ec28378de8a2e046a0e1fdeafb87f5752" => :yosemite
    sha256 "fd11b9954e0b54b71bf2df8422eabad0089753cb9440adcd3aecb362a20ac189" => :mavericks
  end

  option "without-check", "Skip build-time tests (not recommended)"
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
              --enable-gw-dpc
           ]

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
      # Patch to make libXC 2.2+ supported by Abinit 7.10;
      # libXC 2.2 will be supported in Abinit 8.0
      inreplace "configure", "(major != 2) || (minor < 0) || (minor > 1)",
                             "(major != 2) || (minor < 2) || (minor > 3)"
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

    if build.with? "check"
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
