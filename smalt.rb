class Smalt < Formula
  desc "Aligns DNA sequencing reads with a reference genome"
  homepage "http://www.sanger.ac.uk/science/tools/smalt-0"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/smalt/smalt-0.7.6.tar.gz"
  sha256 "89ccdfe471edba3577b43de9ebfdaedb5cd6e26b02bf4000c554253433796b31"
  revision 1

  bottle do
    cellar :any
    sha256 "0a511ce20674ff1df84ad75dfb3a0bbbe90f1f0265a4dc4f8d25d33eda866bd3" => :yosemite
    sha256 "68b45d6f971868d1552ef732f7cf049a101b747d735d1e157fdee884c34bd381" => :mavericks
    sha256 "7d2a0d443996d67ef94bbb1a318f108f2ea8a714a9942892c40b94392bd0a8e4" => :mountain_lion
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/smalt/smalt_manual.pdf"
    sha256 "efd52e8429237b27797027477c33e1071f6247616d7705106af256e48307480a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    doc.install resource("manual")
  end

  test do
    assert_match version.to_s, shell_output("smalt version")
  end
end
