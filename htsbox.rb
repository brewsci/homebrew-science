class Htsbox < Formula
  homepage "https://github.com/lh3/htsbox"
  head "https://github.com/lh3/htsbox.git"
  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "4a0b008515d88edea4307d336da15b9950a6e170" => :yosemite
    sha1 "26662eaaea1233820256298ba6788fbc3d5dc1fc" => :mavericks
    sha1 "74cf4e471b03bfb74e52ed92b6a01a159bfc7d56" => :mountain_lion
  end

  #tag "bioinformatics"

  version "r266"
  url "https://github.com/lh3/htsbox/archive/1559856bb799c88a4c9cf5b01a4cfd8846fb05d7.tar.gz"
  sha1 "d7c4d1608eced7823fcab8b6e65bc87f2deab4f2"

  depends_on "htslib"

  def install
    system "make"
    bin.install "htsbox"
    doc.install "README.md"
  end

  test do
    system "#{bin}/htsbox 2>&1 |grep htsbox"
  end
end
