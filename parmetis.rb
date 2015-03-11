class Parmetis < Formula
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz"
  sha1 "e0df69b037dd43569d4e40076401498ee5aba264"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "e9fe981b16ea4e753f20ae1cc129022d1487b2b3b79e21394d677f3b5436ee56" => :yosemite
    sha256 "b8e894f151784f431058f77cbf1b597f0e1fd9b16932cc20cb814cdc280d971f" => :mavericks
    sha256 "a8dabf7f98547bc43fdfe8f9e120d12c8a68552b8f61e9c88d6f4ed631b95d44" => :mountain_lion
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
    share.install "Graphs" # Sample data for test
  end

  test do
    system "mpirun", "-np", "4", "#{bin}/ptest", "#{share}/Graphs/rotor.graph"
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
