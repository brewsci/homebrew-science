class OmeFiles < Formula
  desc "Open Microscopy Environment (OME) File scientific image I/O library"
  homepage "https://www.openmicroscopy.org/site/products/ome-files-cpp/"
  url "https://downloads.openmicroscopy.org/ome-files-cpp/0.2.2/source/ome-files-cpp-0.2.2.tar.xz"
  sha256 "e75ce6fd12e05e382fa6c916c473d31a28a90eee3f24e5ecfa9a650c0de8033d"
  head "https://github.com/ome/ome-files-cpp.git", :branch => "develop", :shallow => false

  bottle do
    sha256 "6118272d011277c5f3a4b64061e7a21fc1876952d99361333913a695f0d40d4e" => :sierra
    sha256 "fc5d0c213f8bd5de183a4d41e8773e2b16c3418028bc8fddcbc4c89ec6cb4dc5" => :el_capitan
    sha256 "0ee5596d2e817306cc10f09679e9e10d34f17e8cd57fb87a6a8be271dce0675f" => :yosemite
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

  # Required python modules for docs
  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha256 "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  def install
    # Set up python modules
    ENV.prepend_create_path "PYTHONPATH", buildpath/"python/lib/python2.7/site-packages"
    ENV.prepend_path "PATH", buildpath/"python/bin"
    ENV.prepend_create_path "CMAKE_PROGRAM_PATH", buildpath/"python/bin"
    resources.each do |r|
      next if r.name == "gtest"
      next if build.without?("docs")
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
