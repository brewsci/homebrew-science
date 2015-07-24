class P4est < Formula
  homepage "http://www.p4est.org"
  url "http://p4est.github.io/release/p4est-1.1.tar.gz"
  sha1 "ed8737d82ef4c97b9dfa2fd6e5134226f24c9b0b"

  bottle do
    revision 1
    sha256 "c103995bfa2358b28151e9047e4c56c10eaf653b82a1afb90cf2f6952bfededb" => :yosemite
    sha256 "c92f14f4493858e9d759a773ba5ec8c113a13e0e500ce19f264c6ba37926612c" => :mavericks
    sha256 "585ae796954969ae2ccba1e90aebaed7385b457addbe0ec337f78b73549b350e" => :mountain_lion
  end

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
      blas = "BLAS_LIBS=-L#{Formula['openblas'].opt_lib} -lopenblas"
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
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
