class P4est < Formula
  desc "Dynamic management of a collection (a forest) of adaptive octrees in parallel"
  homepage "http://www.p4est.org"
  url "https://p4est.github.io/release/p4est-1.1.tar.gz"
  sha256 "0b5327a35f0c869bf920b8cab5f20caa4eb55692eaaf1f451d5de30285b25139"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "2b0996c9004c063cf4ef66974a89cc64e407fcb516e50b1da4930f4745c1c108" => :el_capitan
    sha256 "02f1cdc1676238fc7095802cdb982a52f8d9c42df37878373a52114f417946b6" => :yosemite
    sha256 "373ab802626785b1f17fdda807ef094cb2e4f654fe3d99318ebbed30823a6d15" => :mavericks
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
    ENV.deparallelize { system "make", "check" } if build.with? "check"
    system "make", "install"
  end
end
