class Bamhash < Formula
  homepage "https://github.com/DecodeGenetics/BamHash"
  # doi "10.1101/015867"
  # tag "bioinformatics"

  url "https://github.com/DecodeGenetics/BamHash/archive/v1.0.tar.gz"
  sha1 "1e7f6d31bee0ea66b60150c8ef587a10cb90af26"
  head "https://github.com/DecodeGenetics/BamHash.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "7b0a924e7d19c6f24c0a3ad3a13cb1623ef2f4c8" => :yosemite
    sha1 "e87aab324de4290409cc764eb0ca4cf35b57a7b6" => :mavericks
    sha1 "64688eea9d72ea394f705a27aa107ef142236fef" => :mountain_lion
  end

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
