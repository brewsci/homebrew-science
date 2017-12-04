class OmeFiles < Formula
  include Language::Python::Virtualenv

  desc "Open Microscopy Environment (OME) File scientific image I/O library"
  homepage "https://www.openmicroscopy.org/site/products/ome-files-cpp/"
  url "https://downloads.openmicroscopy.org/ome-files-cpp/0.5.0/source/ome-files-cpp-0.5.0.tar.xz"
  sha256 "5a89daea8be0efe74baa11431afda7e0b6e240b3ea8d2027e39db80ee67866d7"
  head "https://github.com/ome/ome-files-cpp.git", :branch => "develop", :shallow => false

  bottle do
    sha256 "bb7933a9bb5f4263f01eea70910d7fdf5b44bef2c2742fc35cc75fb77ad7de13" => :high_sierra
    sha256 "024f527e864bf220360391adeeb84e93c42271d2bcfae52b923b37b2224e8b02" => :sierra
    sha256 "a794c739420c10205cd46f6b4ac366044a11d746ecddc444a9f8850d481488de" => :el_capitan
    sha256 "010cf8521188188cff8dd5836b6090635941c6e298c186d7bfb491013dbdf091" => :x86_64_linux
  end

  option "with-api-docs", "Build API reference"
  option "without-docs", "Build man pages and manual using sphinx"
  option "without-test", "Skip build time tests (not recommended)"

  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "graphicsmagick" => :optional # For unit tests only
  depends_on "ome-common"
  depends_on "ome-xml"
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

    if build.with?("docs")
      pip_packages = [
        "alabaster==0.7.10",
        "Babel==2.5.1",
        "certifi==2017.11.5",
        "chardet==3.0.4",
        "docutils==0.14",
        "idna==2.6",
        "imagesize==0.7.1",
        "Jinja2==2.10",
        "MarkupSafe==1.0",
        "Pygments==2.2.0",
        "pytz==2017.3",
        "requests==2.18.4",
        "six==1.11.0",
        "snowballstemmer==1.2.1",
        "Sphinx==1.6.5",
        "sphinxcontrib-websupport==1.0.1",
        "typing==3.6.2",
        "urllib3==1.22",
      ]
      venv = virtualenv_create(buildpath/"python")
      venv.pip_install pip_packages if build.with?("docs")
      ENV.prepend_path "CMAKE_PROGRAM_PATH", buildpath/"python/bin"
    end

    args = *std_cmake_args + [
      "-DGTEST_ROOT=#{buildpath}/gtest",
      "-Wno-dev",
    ]

    args << ("-Ddoxygen:BOOL=" + (build.with?("api-docs") ? "ON" : "OFF"))
    args << ("-Dsphinx:BOOL=" + (build.with?("docs") ? "ON" : "OFF"))

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "ctest", "-V"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/ome-files", "--usage"
    system "#{bin}/ome-files", "info", "--usage"
  end
end
