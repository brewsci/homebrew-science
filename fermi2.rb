class Fermi2 < Formula
  homepage "https://github.com/lh3/fermi2"
  # tag "bioinformatics"
  url "https://github.com/lh3/fermi2/archive/0.1.tar.gz"
  sha256 "1308ce95505270b1aac8ab4d115d19809eebd3ba0e2ee18a66c90c4c78dd2366"

  bottle do
    cellar :any
    sha256 "ca79efffdf75b8943314d713357fccef22c2d66da853cf91457fff66430e78ac" => :yosemite
    sha256 "e3c3944c79d7f857ac5a8a67ec778d4e199ef85b4d18b56314d84eecb0404645" => :mavericks
    sha256 "5037d2613a91c6662e9b5d405a012fb898da42edc857c38f2661d4b3b9c334de" => :mountain_lion
    sha256 "68b30acd0bf8f8d7009bf46faab53f9832570db92ff830eb0d6178a624599b79" => :x86_64_linux
  end

  depends_on "ropebwt2"

  def install
    system "make"
    bin.install "fermi2", "fermi2.pl"
    prefix.install "fermi2.js"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/fermi2 2>&1", 1)
  end
end
