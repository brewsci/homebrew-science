require 'formula'

class Bedtools < Formula
  homepage 'https://github.com/arq5x/bedtools2'
  #doi '10.1093/bioinformatics/btq033'
  #tag "bioinformatics"
  url "https://github.com/arq5x/bedtools2/releases/download/v2.21.0/bedtools-2.21.0.tar.gz"
  sha1 "ceeb1871bec66e90f68a1bef24d82c06669c47d8"
  head 'https://github.com/arq5x/bedtools2.git'

  def install
    system 'make'
    prefix.install 'bin'
    doc.install %w[README.md RELEASE_HISTORY]
  end

  test do
    system "#{bin}/bedtools --version"
  end
end
