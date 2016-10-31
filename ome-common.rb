class OmeCommon < Formula
  desc "Open Microscopy Environment (OME) common functionality"
  homepage "https://www.openmicroscopy.org/site/products/ome-files-cpp/"
  url "https://downloads.openmicroscopy.org/ome-common-cpp/5.3.2/source/ome-common-cpp-5.3.2.tar.xz"
  sha256 "12dc65ddf6813e272412fcf65da58a3a56eb41873da6113f93ada57bd7402fbf"
  head "https://github.com/ome/ome-common-cpp.git", :branch => "develop", :shallow => false

  bottle do
    sha256 "e42ef6bdde96633c2b06e2b61b1b2f0f2839f1cfb468219105c032e876822bdd" => :sierra
    sha256 "df8f8be0536c58a5876fc7a744c8547b5f22c25f7182b89e221eeb4978b8546d" => :el_capitan
    sha256 "96e83f1de862a2e307faf38791b34a129eb8094f947c55d810b671614335a1f1" => :yosemite
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
    system ENV.cxx, "test.cpp", "-I#{opt_include}", "-L#{opt_lib}", "-L#{Formula["boost"].opt_lib}", "-L#{Formula["xerces-c"].opt_lib}", "-L#{Formula["xalan-c"].opt_lib}", "-pthread", "-lome-common", "-lxerces-c", "-lxalan-c", "-lboost_filesystem-mt", "-lboost_system-mt", "-o", "test"
    system "./test"
  end
end
