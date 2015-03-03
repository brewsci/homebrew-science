class Bamhash < Formula
  homepage "https://github.com/DecodeGenetics/BamHash"
  # doi "10.1101/015867"
  # tag "bioinformatics"

  url "https://github.com/DecodeGenetics/BamHash/archive/v1.0.tar.gz"
  sha1 "1e7f6d31bee0ea66b60150c8ef587a10cb90af26"
  head "https://github.com/DecodeGenetics/BamHash.git"

  depends_on "openssl"

  def install
    system "make"
    bin.install "bamhash_checksum_bam", "bamhash_checksum_fastq"
    doc.install "LICENSE", "README.md"
  end

  test do
    system "#{bin}/bamhash_checksum_bam", "--version"
  end
end
