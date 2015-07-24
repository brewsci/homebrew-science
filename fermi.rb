class Fermi < Formula
  homepage "https://github.com/lh3/fermi"
  # doi "10.1093/bioinformatics/bts280"
  # tag "bioinformatics"

  url "https://github.com/lh3/fermi/archive/1.1.tar.gz"
  sha1 "95d9a78df345def9ac781be0485b5c7680e0ad04"
  head "https://github.com/lh3/fermi.git"

  bottle do
    cellar :any
    sha1 "16c506171d368f987101a2c359db1531afb3e882" => :yosemite
    sha1 "4ba4cd1501553930efcddd24d14ce84656f34569" => :mavericks
  end

  def install
    system "make"
    prefix.install "README.md"
    bin.install "fermi", "run-fermi.pl"
  end

  test do
    system "#{bin}/fermi 2>&1 |grep -q fermi"
  end
end
