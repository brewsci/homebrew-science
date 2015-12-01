class P4est < Formula
  desc "Dynamic management of a collection (a forest) of adaptive octrees in parallel"
  homepage "http://www.p4est.org"
  url "https://p4est.github.io/release/p4est-1.1.tar.gz"
  sha256 "0b5327a35f0c869bf920b8cab5f20caa4eb55692eaaf1f451d5de30285b25139"
  revision 1

  bottle do
    cellar :any
    sha256 "e94aeee5d338f8ca93b8cc810b3ff491df11c39cc40a147dab90f29fcd441721" => :el_capitan
    sha256 "ee2eb5511d16d6a586ef53f72c54a378ec52f3dbe6af1aa4485ab032290cd57d" => :yosemite
    sha256 "2ed7ad754a9f7950e578e3e4e443cfd4955037ad057df5ab692cd8cebae35846" => :mavericks
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
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
