class P4est < Formula
  homepage "http://www.p4est.org"
  url "http://p4est.github.io/release/p4est-1.1.tar.gz"
  sha1 "ed8737d82ef4c97b9dfa2fd6e5134226f24c9b0b"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "1bf6edb568ebe582ec59898bfd73e3e98c0ae590" => :yosemite
    sha1 "1f3d473574d2e3f7b494dbd10563b3e2ed0d6dd1" => :mavericks
    sha1 "b976a1732e4e9f79eeb20822f95c983da560d4f0" => :mountain_lion
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
