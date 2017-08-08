class EnblendEnfuse < Formula
  desc "Combines images that overlap"
  homepage "https://enblend.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/enblend/enblend-enfuse/enblend-enfuse-4.2/enblend-enfuse-4.2.tar.gz"
  sha256 "8703e324939ebd70d76afd350e56800f5ea2c053a040a5f5218b2a1a4300bd48"
  revision 2

  bottle do
    cellar :any
    sha256 "f6b3add9c50086e72a9bacd3bd7753634528345e533b1761bff0280185c0dff7" => :sierra
    sha256 "c176753e88c4b03811363dc6a4ac3cc9e467db2b10cfa4ea024206fb7680dc00" => :el_capitan
    sha256 "1fc56d398dd031927a1e7da81d27e735f979071cf9c9336b32714d2c9d6686cb" => :yosemite
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
