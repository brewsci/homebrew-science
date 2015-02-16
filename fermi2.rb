class Fermi2 < Formula
  homepage "https://github.com/lh3/fermi2"
  # tag "bioinformatics"
  url "https://github.com/lh3/fermi2/archive/0.1.tar.gz"
  sha256 "1308ce95505270b1aac8ab4d115d19809eebd3ba0e2ee18a66c90c4c78dd2366"

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
