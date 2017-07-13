class OmeCommon < Formula
  desc "Open Microscopy Environment (OME) common functionality"
  homepage "https://www.openmicroscopy.org/site/products/ome-files-cpp/"
  url "https://downloads.openmicroscopy.org/ome-common-cpp/5.4.2/source/ome-common-cpp-5.4.2.tar.xz"
  sha256 "16dde8fc2197267177430b8766da9c64ceee2e68161be66d28b611569fb1035b"
  head "https://github.com/ome/ome-common-cpp.git", :branch => "develop", :shallow => false

  bottle do
    sha256 "d203264e53f1382666e45e1572bbdb14a6a5c4829d6977cf94866092a487cc1c" => :sierra
    sha256 "012d01a618b7f6425296be3545c3e00e14dff32404774a2c44cde6a426f1c791" => :el_capitan
    sha256 "f6702a567d27d6d7edc38f2010399e0ee8b1e9c9f0570c0c171f0312b9904b31" => :yosemite
    sha256 "d5f56278cf2bd7b8ee2600d890a09069abac1816f57939ece16706ce42b3ffaa" => :x86_64_linux
  end

  option "with-api-docs", "Build API reference"
  option "without-test", "Skip build time tests (not recommended)"

  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "xalan-c"
  depends_on "xerces-c"
  depends_on "doxygen" => :build if build.with? "api-docs"
  depends_on "graphviz" => :build if build.with? "api-docs"

  # Needs clang/libc++ toolchain; mountain lion is too broken
  depends_on MinimumMacOSRequirement => :mavericks

  # Required for testing
  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    if build.with? "test"
      (buildpath/"gtest-source").install resource("gtest")

      gtest_args = *std_cmake_args + [
        "-DCMAKE_INSTALL_PREFIX=#{buildpath}/gtest",
      ]

      cd "gtest-source" do
        system "cmake", ".", *gtest_args
        system "make", "install"
      end
    end

    args = *std_cmake_args + [
      "-DGTEST_ROOT=#{buildpath}/gtest",
      "-Wno-dev",
    ]

    args << ("-Ddoxygen:BOOL=" + (build.with?("api-docs") ? "ON" : "OFF"))

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "ctest", "-V"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ome/common/xml/Platform.h>
      #include <ome/common/xsl/Platform.h>

      int main()
      {
        ome::common::xml::Platform xmlplat;
        ome::common::xsl::Platform xslplat;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{opt_include}", "-L#{opt_lib}", "-L#{Formula["boost"].opt_lib}", "-L#{Formula["xerces-c"].opt_lib}", "-L#{Formula["xalan-c"].opt_lib}", "-pthread", "-lome-common", "-lxerces-c", "-lxalan-c", "-lboost_filesystem-mt", "-lboost_system-mt", "-o", "test"
    system "./test"
  end
end
