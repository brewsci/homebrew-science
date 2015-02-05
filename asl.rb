class Asl < Formula
  homepage "http://www.ampl.com"
  url "https://github.com/ampl/mp/archive/1.3.0.tar.gz"
  sha1 "0581cdbfbeeb54a0f2ebac65ba39aa3ccb36a926"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "d878c7f1c29d185a60c9a4718d5c98384c8a037c" => :yosemite
    sha1 "9faf1043a4437025601c9a6430044860d89ff424" => :mavericks
    sha1 "41b1d69e0d7ca2c989c94866b7ec502f3849d051" => :mountain_lion
  end

  option "with-matlab", "Build MEX files for use with Matlab"
  option "with-mex-path=", "Path to MEX executable, e.g., /path/to/MATLAB.app/bin/mex (default: mex)"

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional

  # https://github.com/ampl/mp/issues/24
  # https://github.com/ampl/mp/issues/27
  patch :DATA

  resource "miniampl" do
    url "https://github.com/dpo/miniampl/archive/v1.0.tar.gz"
    sha1 "4518ee9a9895b0782169085126ee149d05ba66a7"
  end

  def install
    cmake_args = ["-DCMAKE_INSTALL_PREFIX=#{libexec}", "-DCMAKE_BUILD_TYPE=None",
                  "-DCMAKE_FIND_FRAMEWORK=LAST", "-DCMAKE_VERBOSE_MAKEFILE=ON", "-Wno-dev",
                  "-DBUILD_SHARED_LIBS=True"]
    cmake_args << ("-DMATLAB_MEX=" + (ARGV.value("with-mex-path") || "mex")) if build.with? "matlab"

    system "cmake", ".", *cmake_args
    system "make", "all"
    system "make", "test"
    system "make", "install"

    lib.mkdir
    ln_sf Dir["#{libexec}/lib/*.a"], lib
    ln_sf Dir["#{libexec}/lib/*.dylib"], lib

    include.mkdir
    ln_sf Dir["#{libexec}/include/*"], include

    if build.with? "matlab"
      mkdir_p (share / "asl/matlab")
      ln_sf Dir["#{libexec}/bin/*.mexmaci64"], (share / "asl/matlab")
    end

    resource("miniampl").stage do
      system "make", "SHELL=/bin/bash", "CXX=#{ENV["CC"]} -std=c99", "LIBAMPL_DIR=#{prefix}", "LIBS=-L$(LIBAMPL_DIR)/lib -lasl -lm -ldl"
      bin.install "bin/miniampl"
      (share / "asl/example").install "Makefile", "README.rst", "src", "examples"
    end
  end

  def caveats
    s = ""
    if build.with? "matlab"
      s += <<-EOS.undent
        Matlab interfaces have been installed to

          #{opt_share}/asl/matlab
      EOS
    end
    s
  end

  test do
    system "#{bin}/miniampl", "#{share}/asl/example/examples/wb", "showname=1", "showgrad=1"
  end
end

__END__
diff --git a/test/os-test.cc b/test/os-test.cc
index 52c4f5c..d6bb6c4 100644
--- a/test/os-test.cc
+++ b/test/os-test.cc
@@ -296,9 +296,9 @@ TEST(MemoryMappedFileTest, CloseFile) {
     // Running lsof with filename failed, so check the full lsof output instead.
     ExecuteShellCommand("lsof > out", false);
     std::string line;
-    std::ifstream out("out");
+    std::ifstream ifs("out");
     bool found = false;
-    while (std::getline(out, line)) {
+    while (std::getline(ifs, line)) {
       if (line.find(path) != std::string::npos) {
         if (line.find(MEM) != string::npos)
           found = true;

diff --git a/src/asl/CMakeLists.txt b/src/asl/CMakeLists.txt
index f8cc9c6..c4dd762 100644
--- a/src/asl/CMakeLists.txt
+++ b/src/asl/CMakeLists.txt
@@ -281,6 +281,7 @@ if (MATLAB_FOUND)
       COMPILE_FLAGS -I${CMAKE_CURRENT_BINARY_DIR}
                     -I${solvers_dir} ${MP_MEX_OPTIONS}
       LIBRARIES ${matlab_asl})
+    install(FILES $<TARGET_PROPERTY:${name},FILENAME> DESTINATION bin)
   endforeach ()
 endif ()

diff --git a/support/cmake/FindMATLAB.cmake b/support/cmake/FindMATLAB.cmake
index 7c6bb76..cf27f5c 100644
--- a/support/cmake/FindMATLAB.cmake
+++ b/support/cmake/FindMATLAB.cmake
@@ -7,7 +7,7 @@

 if (APPLE)
   set(MATLAB_GLOB "/Applications/MATLAB*")
-  set(MATLAB_MEX_SUFFIX mac)
+  set(MATLAB_MEX_SUFFIX maci64)
 elseif (UNIX)
   set(MATLAB_GLOB "/opt/MATLAB/*")
   set(MATLAB_MEX_SUFFIX a64)
@@ -51,4 +51,5 @@ function (add_mex name)
       ${sources} ${libs} -output ${filename}
     DEPENDS ${sources} ${add_mex_LIBRARIES})
   add_custom_target(${name} ALL SOURCES ${filename})
+  set_target_properties(${name} PROPERTIES FILENAME ${filename})
 endfunction ()
