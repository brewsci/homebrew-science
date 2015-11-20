class Bamhash < Formula
  homepage "https://github.com/DecodeGenetics/BamHash"
  # doi "10.1101/015867"
  # tag "bioinformatics"

  url "https://github.com/DecodeGenetics/BamHash/archive/v1.0.tar.gz"
  sha1 "1e7f6d31bee0ea66b60150c8ef587a10cb90af26"
  head "https://github.com/DecodeGenetics/BamHash.git"

  bottle do
    cellar :any
    sha256 "9855449314d5564d4b3ef17b352ba5e9b73b434abc33b8630216314845a38cc3" => :yosemite
    sha256 "a8ed1f99684cce5919fff31c4a0cad8c0e2b7b3a1063800f61b217a3b0af1689" => :mavericks
    sha256 "5047df46a901e94da014a98802bd27143335ecb9beb2913f4586b3b428895984" => :mountain_lion
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
