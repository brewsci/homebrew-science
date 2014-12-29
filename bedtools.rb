require "formula"

class Bedtools < Formula
  homepage "https://github.com/arq5x/bedtools2"
  #doi "10.1093/bioinformatics/btq033"
  #tag "bioinformatics"
  url "https://github.com/arq5x/bedtools2/releases/download/v2.22.0/bedtools-2.22.0.tar.gz"
  sha1 "96f9f7031806de5d4ec694aeb9db31c3f8188f9b"
  head "https://github.com/arq5x/bedtools2.git"

  def install
    system "make"
    prefix.install "bin"
    doc.install %w[README.md RELEASE_HISTORY]
  end

  test do
    system "#{bin}/bedtools", "--version"
  end
end
