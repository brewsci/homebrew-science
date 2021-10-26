class P4est < Formula
  desc "Dynamic management of a collection (a forest) of adaptive octrees in parallel"
  homepage "http://www.p4est.org"
  url "https://p4est.github.io/release/p4est-1.1.tar.gz"
  sha256 "0b5327a35f0c869bf920b8cab5f20caa4eb55692eaaf1f451d5de30285b25139"
  revision 4

  head do
    url "https://github.com/cburstedde/p4est.git", branch: "master"
    version "1.2pre"
  end

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on "gcc" if OS.mac?
  depends_on "open-mpi" # for gfortran
  depends_on "openblas" => :optional

  def install
    ENV["CC"]       = ENV["MPICC"]
    ENV["CXX"]      = ENV["MPICXX"]
    ENV["F77"]      = ENV["MPIF77"]
    ENV["FC"]       = ENV["MPIFC"]
    ENV["CFLAGS"]   = "-O2"
    ENV["CPPFLAGS"] = "-DSC_LOG_PRIORITY=SC_LP_ESSENTIAL"

    blas = if build.with? "openblas"
      "BLAS_LIBS=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      "BLAS_LIBS=-framework Accelerate"
    else
      "BLAS_LIBS=-lblas -llapack"
    end

    system "./configure", "--enable-mpi",
                          "--enable-shared",
                          "--disable-vtk-binary",
                          blas.to_s,
                          "--prefix=#{prefix}"

    system "make"
    ENV.deparallelize { system "make", "check" } if build.with? "check"
    system "make", "install"
  end
end
