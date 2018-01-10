class Kmerstream < Formula
  desc "Streaming algorithms for k-mer abundance estimation"
  homepage "https://github.com/pmelsted/KmerStream"
  url "https://github.com/pmelsted/KmerStream/archive/v1.1.tar.gz"
  sha256 "cf5de6224a0dd40e30af4ccc464bb749d20d393a7d4d3fceafab5f3d75589617"
  revision 1
  head "https://github.com/pmelsted/KmerStream.git"
  # doi "10.1093/bioinformatics/btu713"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "ae57c28ea2005478bb32f78448d239e53ab0b4be50635086ee3753ee52256f69" => :sierra
    sha256 "800c38f604b71b2048ff252168305be3855f9767b7dd183a487701707a7e2226" => :el_capitan
    sha256 "67af773688af575858ceee55a5d6b008b347f9c3101e63cb2e406bfb023b924b" => :yosemite
    sha256 "bbcbe67ac973a7414b26322a81dc9c9e7ebddf8ed3b8be7fadb15994f2dc214b" => :x86_64_linux
  end

  needs :openmp
  depends_on "scipy"

  def install
    system "make"
    bin.install "KmerStream", "KmerStreamJoin", "KmerStreamEstimate.py"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/KmerStream 2>&1", 1)
    assert_match "Usage", shell_output("#{bin}/KmerStreamJoin 2>&1", 1)
    assert_match "Usage", shell_output("#{bin}/KmerStreamEstimate.py 2>&1", 1)
  end
end
