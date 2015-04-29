class Trimadap < Formula
  homepage "https://github.com/lh3/trimadap"
  # tag "bioinformatics"

  url "https://github.com/lh3/trimadap/archive/0.1.tar.gz"
  sha256 "553069d81004b120d9df7d6161edce9317c0f95e5eefe2ec3325dd4081a90acd"

  def install
    system "make"
    bin.install "trimadap-mt"
    doc.install "README.md", "illumina.txt", "test.fa"
  end

  test do
    assert_match "ACGT", shell_output("#{bin}/trimadap-mt /dev/null 2>&1")
  end
end
