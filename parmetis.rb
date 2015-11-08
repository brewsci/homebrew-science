class Parmetis < Formula
  desc "MPI-based library for graph/mesh partitioning and computing fill-reducing orderings"
  homepage "http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz"
  sha256 "f2d9a231b7cf97f1fee6e8c9663113ebf6c240d407d3c118c55b3633d6be6e5f"
  revision 3

  bottle do
    cellar :any
    sha256 "97d9155206582f0005bcc622d8a397fdc57f6c5e853d41cf2600e315e367a679" => :yosemite
    sha256 "7b600352e2d137de385d6fd436d9ef1410d73c28ca069b1079377125ef414ead" => :mavericks
    sha256 "071cf81ba1611fa0a3b2fb9383308cfe8c79c3cbacfd958f5ffc0cba3199b8d1" => :mountain_lion
  end

  # METIS 5.* is required. It comes bundled with ParMETIS.
  # We prefer to brew it ourselves.
  depends_on "metis"

  depends_on "cmake" => :build
  depends_on :mpi => :cc

  # Do not build the METIS 5.* that ships with ParMETIS.
  patch :DATA

  # bug fixes from PETSc developers
  patch do
    url "https://bitbucket.org/petsc/pkg-parmetis/commits/82409d68aa1d6cbc70740d0f35024aae17f7d5cb/raw/"
    sha256 "d72c9a656a33b6715cc1601a4a1a89944da00e9911b4ab2d3908d41a32dee31b"
  end

  patch do
    url "https://bitbucket.org/petsc/pkg-parmetis/commits/1c1a9fd0f408dc4d42c57f5c3ee6ace411eb222b/raw/"
    sha256 "11b909a346f4dd8ec73b17ecb0c7215524e3793e252c749bb3199e83fa294597"
  end

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

diff --git a/libparmetis/CMakeLists.txt b/libparmetis/CMakeLists.txt
index 9cfc8a7..dfc0125 100644
--- a/libparmetis/CMakeLists.txt
+++ b/libparmetis/CMakeLists.txt
@@ -5,7 +5,7 @@ file(GLOB parmetis_sources *.c)
 # Create libparmetis
 add_library(parmetis ${ParMETIS_LIBRARY_TYPE} ${parmetis_sources})
 # Link with metis and MPI libraries.
-target_link_libraries(parmetis metis ${MPI_LIBRARIES})
+target_link_libraries(parmetis metis ${MPI_LIBRARIES} "-lm")
 set_target_properties(parmetis PROPERTIES LINK_FLAGS "${MPI_LINK_FLAGS}")

 install(TARGETS parmetis
