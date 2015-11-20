class Sickle < Formula
  homepage "https://github.com/najoshi/sickle"
  # tag "bioinformatics

  url "https://github.com/najoshi/sickle/archive/v1.33.tar.gz"
  sha1 "593274fb7e12a52c9086dff69623aedca1799a5c"
  head "https://github.com/najoshi/sickle.git"

  bottle do
    cellar :any
    sha256 "eb4555ff573507d200d64bb30ad6942fd3dfb868ef264d19f13620cf0fc7c8b7" => :yosemite
    sha256 "d0bb7a585523d2421837ee81feb7ee38833a642f8b10e1ff3587a156fcc41105" => :mavericks
    sha256 "d3a236d00a622e1130865ac83807281b32e1e2ae18747e5de533a8c8c5b5cb70" => :mountain_lion
  end

  def install
    system "make"
    bin.install "sickle"
    doc.install "README.md"
  end

  test do
    system "#{bin}/sickle", "--version"
  end
end
