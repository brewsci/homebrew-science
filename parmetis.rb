class Parmetis < Formula
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  desc "MPI-based library for graph/mesh partitioning and computing fill-reducing orderings"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz"
  sha1 "e0df69b037dd43569d4e40076401498ee5aba264"

  bottle do
    cellar :any
    revision 2
    sha256 "98818f2f53c82461dd816b6b86cd569d05ba1d341c470d4948195397a9b1f7a1" => :yosemite
    sha256 "adacf5ac72bed2a487598817eaac83f854d47f5d7163bc00f2b070aeb71c3959" => :mavericks
    sha256 "f5a81fe89fbdddcc211dad3cee285af03cfd7e022f46ac2e00993a87c8e97e5e" => :mountain_lion
  end

  # METIS 5.* is required. It comes bundled with ParMETIS.
  # We prefer to brew it ourselves.
  depends_on "metis"

  depends_on "cmake" => :build
  depends_on :mpi => :cc

  # Do not build the METIS 5.* that ships with ParMETIS.
  patch :DATA

  def install
    ENV["LDFLAGS"] = "-L#{Formula["metis"].lib} -lmetis -lm"

    system "make", "config", "prefix=#{prefix}", "shared=1"
    system "make", "install"
    pkgshare.install "Graphs" # Sample data for test
  end

  test do
    system "mpirun", "-np", "4", "#{bin}/ptest", "#{pkgshare}/Graphs/rotor.graph"
    ohai "Test results are in ~/Library/Logs/Homebrew/parmetis."
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index ca945dd..1bf94e9 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -33,7 +33,7 @@ include_directories(${GKLIB_PATH})
 include_directories(${METIS_PATH}/include)

 # List of directories that cmake will look for CMakeLists.txt
-add_subdirectory(${METIS_PATH}/libmetis ${CMAKE_BINARY_DIR}/libmetis)
+#add_subdirectory(${METIS_PATH}/libmetis ${CMAKE_BINARY_DIR}/libmetis)
 add_subdirectory(include)
 add_subdirectory(libparmetis)
 add_subdirectory(programs)
