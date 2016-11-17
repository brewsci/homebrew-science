class OmeXml < Formula
  desc "Open Microscopy Environment (OME) XML metadata model"
  homepage "https://www.openmicroscopy.org/site/products/ome-files-cpp/"
  url "http://downloads.openmicroscopy.org/bio-formats/5.2.4/artifacts/bioformats-dfsg-5.2.4.tar.xz"
  sha256 "4e50c4a6936514d1085f05bdbdd009966b61428a97415bf6a4d4d27667b7ff15"
  head "https://github.com/openmicroscopy/bioformats.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    sha256 "e3f575ef2795b2b1569f4699a79e9c14c3c841b53191f3afa6cf92c51f0923ea" => :sierra
    sha256 "6ad1c23c68e1c160c704b2d4cb192c2ffc82a678ccc280221253a69041ffd236" => :el_capitan
    sha256 "a6972ac3e49b34b38d0e4f1afd4cfb2b1603db375bc6fdefeae2a1c077b9212c" => :yosemite
  end

  option "with-api-docs", "Build API reference"
  option "without-test", "Skip build time tests (not recommended)"

  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "xalan-c"
  depends_on "xerces-c"
  depends_on "ome-common"
  depends_on "doxygen" => :build if build.with? "api-docs"
  depends_on "graphviz" => :build if build.with? "api-docs"

  # Needs clang/libc++ toolchain; mountain lion is too broken
  depends_on MinimumMacOSRequirement => :mavericks

  # Required for testing
  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  # Required python module for main build
  resource "genshi" do
    url "https://pypi.python.org/packages/source/G/Genshi/Genshi-0.7.tar.gz"
    sha256 "1d154402e68bc444a55bcac101f96cb4e59373100cc7a2da07fbf3e5cc5d7352"
  end

  def install
    # Set up python modules
    ENV.prepend_create_path "PYTHONPATH", buildpath/"python/lib/python2.7/site-packages"
    ENV.prepend_path "PATH", buildpath/"python/bin"
    ENV.prepend_create_path "CMAKE_PROGRAM_PATH", buildpath/"python/bin"
    resources.each do |r|
      next unless r.name == "genshi"
      r.stage do
        system "python", *Language::Python.setup_install_args(buildpath/"python")
      end
    end

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
      #include <ome/xml/meta/OMEXMLMetadata.h>

      int main()
      {
        ome::xml::meta::OMEXMLMetadata meta;
        ome::xml::model::detail::OMEModel model;
        ome::compat::shared_ptr<ome::xml::meta::OMEXMLMetadataRoot> root(ome::compat::dynamic_pointer_cast<ome::xml::meta::OMEXMLMetadataRoot>(meta.getRoot()));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{opt_include}", "-L#{opt_lib}", "-L#{Formula["ome-common"].opt_lib}", "-L#{Formula["boost"].opt_lib}", "-L#{Formula["xerces-c"].opt_lib}", "-L#{Formula["xalan-c"].opt_lib}", "-pthread", "-lome-common", "-lome-xml", "-lxerces-c", "-lxalan-c", "-lboost_filesystem-mt", "-lboost_system-mt", "-o", "test"
    system "./test"
  end
end
