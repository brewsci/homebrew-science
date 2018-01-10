class Bioawk < Formula
  desc "awk modified for biological data"
  homepage "https://github.com/lh3/bioawk"
  # tag "bioinformatics"

  url "https://github.com/lh3/bioawk/archive/v1.0.tar.gz"
  sha256 "5cbef3f39b085daba45510ff450afcf943cfdfdd483a546c8a509d3075ff51b5"

  head "https://github.com/lh3/bioawk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebc6d6a5e8558719af2550297f1efd99e9e9da1e9f93ea9e908df1886fd99cb1" => :el_capitan
    sha256 "eec121fdc26539ba0b1f2700d8202cc6fb9b235d109af9827b22318337f32e28" => :yosemite
    sha256 "f4ce3593f5495e47a07c77070c29b0184f2f22d641a90d2f5602ffb4d1f3f78c" => :mavericks
    sha256 "6e03d465a7db4cb150038aedb0bec84027e3756243bb6ad021ee314c40f1570a" => :x86_64_linux
  end

  depends_on "bison" => :build

  def install
    ENV.deparallelize
    system "make"
    bin.install "bioawk"
    doc.install "README.md"
    man1.install "awk.1" => "bioawk.1"
  end

  test do
    system "#{bin}/bioawk", "--version"
  end
end
