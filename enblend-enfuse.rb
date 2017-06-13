class EnblendEnfuse < Formula
  desc "Combines images that overlap"
  homepage "https://enblend.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/enblend/enblend-enfuse/enblend-enfuse-4.2/enblend-enfuse-4.2.tar.gz"
  sha256 "8703e324939ebd70d76afd350e56800f5ea2c053a040a5f5218b2a1a4300bd48"

  bottle do
    cellar :any
    sha256 "aa02335826c602b3c2e9a21e8fb893b5fb02a3bbe5ea55b13484bcc0de1fba44" => :sierra
    sha256 "3e9eb11f8b3a4d2c30122193873c00de2d7c8b2396dfe9e659a0a54b671822b1" => :el_capitan
    sha256 "41b2e32fcddeb677971a15e7d0e2645c137b71240d709284c697c349374a1341" => :yosemite
    sha256 "9b1387e83f6fc8faff5a7a236eaf5ec2ebf7c5b3a950040a0a738adbdb986941" => :x86_64_linux
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
