class EnblendEnfuse < Formula
  desc "Combines images that overlap"
  homepage "https://enblend.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/enblend/enblend-enfuse/enblend-enfuse-4.2/enblend-enfuse-4.2.tar.gz"
  sha256 "8703e324939ebd70d76afd350e56800f5ea2c053a040a5f5218b2a1a4300bd48"
  revision 1

  bottle do
    cellar :any
    sha256 "d9346120849be1ab72f4c47253991af898db9d1ffaf093a1b67f83884802eb09" => :sierra
    sha256 "28e1102ff05c71b84a7ed65a6b5ca1305aa970ccc8c4f8cf74e3e4e23a7f7f78" => :el_capitan
    sha256 "f3833fc84f671c5ca0bc38f6e75e5d8a612cb6a00d7beb04b2c3d907be6efc83" => :yosemite
    sha256 "c94db31e7a1140def00b86c23e6c1c9f4d8dbb050712d6442f44e3bd8a533dd2" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "boost"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "little-cms2"
  depends_on "libtiff"
  depends_on "vigra"
  depends_on "openexr" => :optional

  resource "test_image" do
    url "http://www.schaik.com/pngsuite/basn4a08.png"
    sha256 "7be24b618bfd437b921ae0caf9341d112338c6290cc62466deb19d2c7a512968"
  end

  # Fix missing files in the release tar file
  # https://bugs.launchpad.net/enblend/+bug/1568917
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6df9856e0327804ec10de38d5d4a436fd3008640/enblend-enfuse/enblend-enfuse-4.2.patch"
    sha256 "5a2c8f70b3f29364c9082624da22ffa69b2754abd247eeed6f2e50dfe76c1c87"
  end

  def install
    system "cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    testpath.install resource("test_image")
    system "#{bin}/enblend", "basn4a08.png", "basn4a08.png"
    system "#{bin}/enfuse", "basn4a08.png", "basn4a08.png"
  end
end
