class Abinit < Formula
  homepage "http://www.abinit.org"
  url "http://ftp.abinit.org/abinit-7.10.2.tar.gz"
  sha1 "04c4d991bf48de917e9707611a553c6f7c44a961"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "a83e4d643debd45d7c3bcfdd1f20f736a7e64933" => :yosemite
    sha1 "b106a857ba1430ef060d8164d5f6f2cf000e89f3" => :mavericks
    sha1 "93d318b7e3ded576a88ace4b09a208d21dca1b2f" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"
  option "with-testsuite", "Run full test suite (time consuming)"

  depends_on "cmake" => :build
  depends_on :python => :build

  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran
  depends_on "veclibfort"
  depends_on "fftw" => ["with-mpi", "with-fortran", :recommended]
  #-depends_on "libxc" => :recommended   # 2.2.0 will be supported in Abinit 8.0
  #-depends_on "netcdf" => ["with-fortran", :recommended] # Netcdf 4.3.2 Error while closing the OUT.nc file: NetCDF: Not a valid ID
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

    args << "--with-linalg-flavor=custom"
    args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lveclibfort"

    if build.with? "netcdf"
      args << "--with-trio-flavor=netcdf"
      args << "--with-netcdf-incs=-I#{Formula["netcdf"].opt_include}"
      args << "--with-netcdf-libs=-L#{Formula["netcdf"].opt_lib} -lnetcdff -lnetcdf"
    end

    if build.with? "gsl"
      args << "--with-math-flavor=gsl"
      args << "--with-math-incs=-I#{Formula["gsl"].opt_include}"
      args << "--with-math-libs=-L#{Formula["gsl"].opt_lib} -lgsl"
    end

    if build.with? "libxc"
      args << "--with-dft-flavor=libxc"
      args << "--with-libxc-incs=-I#{Formula["libxc"].opt_include}"
      args << "--with-libxc-libs=-L#{Formula["libxc"].opt_lib} -lxc -lxcf90"
    end

    # need to link against single precision as well, see https://trac.macports.org/ticket/45617 and http://forum.abinit.org/viewtopic.php?f=3&t=2631
    if build.with? "fftw"
      args << "--with-fft-flavor=fftw3"
      args << "--with-fft-incs=-I#{Formula["fftw"].opt_include}"
      args << "--with-fft-libs=-L#{Formula["fftw"].opt_lib} -lfftw3 -lfftw3f -lfftw3_mpi -lfftw3f_mpi"
    end

    system "./configure", *args
    system "make"

    if build.with? "check"
      log_name = "make-check.log"
      cd "tests"
      if build.with? "testsuite"
        system "./runtests.py -n 3 2>&1 | tee #{log_name}"
      else
        system "./runtests.py built-in fast 2>&1 | tee #{log_name}"
      end
      ohai `grep ", succeeded:" "#{log_name}"`.chomp
      prefix.install "#{log_name}"
      cd ".."
    end

    system "make", "install"
  end
end
