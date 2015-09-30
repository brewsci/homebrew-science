class Bioawk < Formula
  desc "awk modified for biological data"
  homepage "https://github.com/lh3/bioawk"
  # tag "bioinformatics"

  url "https://github.com/lh3/bioawk/archive/v1.0.tar.gz"
  sha256 "5cbef3f39b085daba45510ff450afcf943cfdfdd483a546c8a509d3075ff51b5"

  head "https://github.com/lh3/bioawk.git"

  bottle do
    cellar :any
    sha1 "ed7b2bcdf5420729429d7c30450250bd1fa4b4d6" => :yosemite
    sha1 "7093a34c9ad55cd869aaa2973bd6777c239d6734" => :mavericks
    sha1 "75262055989014fd83dd0023b8d3a44a1f2ad8ea" => :mountain_lion
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
