require 'formula'

class Bamtools < Formula
  homepage 'https://github.com/pezmaster31/bamtools'
  url 'https://github.com/pezmaster31/bamtools/archive/v2.2.3.tar.gz'
  sha1 '130c20f13948e007516d2d0ec068bcb9685fc8d4'
  head 'https://github.com/pezmaster31/bamtools.git'

  depends_on 'cmake' => :build

  # Install libbamtools in /usr/local/lib.
  # Link statically with libbamtools-util and libjsoncpp, since
  # they're not installed by default. Sent upstream:
  # https://github.com/pezmaster31/bamtools/pull/55
  def patches
    DATA
  end

  def install
    mkdir 'default' do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end

  def test
    system "#{bin}/bamtools", "--version"
  end
end

__END__
diff --git a/src/api/CMakeLists.txt b/src/api/CMakeLists.txt
index 66eb35f..c4df349 100644
--- a/src/api/CMakeLists.txt
+++ b/src/api/CMakeLists.txt
@@ -54,8 +54,8 @@ target_link_libraries( BamTools ${APILibs} )
 target_link_libraries( BamTools-static ${APILibs} )
 
 # set library install destinations
-install( TARGETS BamTools LIBRARY DESTINATION "lib/bamtools" RUNTIME DESTINATION "bin")
-install( TARGETS BamTools-static ARCHIVE DESTINATION "lib/bamtools")
+install( TARGETS BamTools LIBRARY DESTINATION "lib" RUNTIME DESTINATION "bin")
+install( TARGETS BamTools-static ARCHIVE DESTINATION "lib")
 
 # export API headers
 include(../ExportHeader.cmake)
diff --git a/src/third_party/jsoncpp/CMakeLists.txt b/src/third_party/jsoncpp/CMakeLists.txt
index 03c091b..cf95791 100644
--- a/src/third_party/jsoncpp/CMakeLists.txt
+++ b/src/third_party/jsoncpp/CMakeLists.txt
@@ -10,7 +10,7 @@ add_definitions( -DBAMTOOLS_JSONCPP_LIBRARY ) # (for proper exporting of library
 add_definitions( -fPIC ) # (attempt to force PIC compiling on CentOS, not being set on shared libs by CMake)
 
 # create jsoncpp library
-add_library( jsoncpp SHARED
+add_library( jsoncpp STATIC
              json_reader.cpp
              json_value.cpp
              json_writer.cpp
diff --git a/src/utils/CMakeLists.txt b/src/utils/CMakeLists.txt
index 2d91ca3..b38859c 100644
--- a/src/utils/CMakeLists.txt
+++ b/src/utils/CMakeLists.txt
@@ -13,7 +13,7 @@ add_definitions( -DBAMTOOLS_UTILS_LIBRARY ) # (for proper exporting of library s
 add_definitions( -fPIC ) # (attempt to force PIC compiling on CentOS, not being set on shared libs by CMake)
 
 # create BamTools utils library
-add_library( BamTools-utils SHARED
+add_library( BamTools-utils STATIC
              bamtools_fasta.cpp
              bamtools_options.cpp
              bamtools_pileup_engine.cpp
