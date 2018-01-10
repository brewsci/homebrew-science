class P4est < Formula
  desc "Dynamic management of a collection (a forest) of adaptive octrees in parallel"
  homepage "http://www.p4est.org"
  url "https://p4est.github.io/release/p4est-1.1.tar.gz"
  sha256 "0b5327a35f0c869bf920b8cab5f20caa4eb55692eaaf1f451d5de30285b25139"
  revision 4

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  head do
    url "https://github.com/cburstedde/p4est.git", :branch => "master"
    version "1.2pre"
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran
  depends_on "openblas" => :optional

  def install
    ENV["CC"]       = ENV["MPICC"]
    ENV["CXX"]      = ENV["MPICXX"]
    ENV["F77"]      = ENV["MPIF77"]
    ENV["FC"]       = ENV["MPIFC"]
    ENV["CFLAGS"]   = "-O2"
    ENV["CPPFLAGS"] = "-DSC_LOG_PRIORITY=SC_LP_ESSENTIAL"

    if build.with? "openblas"
      blas = "BLAS_LIBS=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      blas = "BLAS_LIBS=-framework Accelerate"
    else
      blas = "BLAS_LIBS=-lblas -llapack"
    end

    system "./configure", "--enable-mpi",
                          "--enable-shared",
                          "--disable-vtk-binary",
                          "#{blas}",
                          "--prefix=#{prefix}"

    system "make"
    ENV.deparallelize { system "make", "check" } if build.with? "check"
    system "make", "install"
  end
end
