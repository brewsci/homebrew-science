require 'formula'

class Bedtools < Formula
  homepage 'https://github.com/arq5x/bedtools2'
  #doi '10.1093/bioinformatics/btq033'
  url 'https://github.com/arq5x/bedtools2/releases/download/v2.20.1/bedtools-2.20.1.tar.gz'
  sha1 '4b7b5866199b0eefd093f39fef260dcd369ae13a'
  head 'https://github.com/arq5x/bedtools2.git'

  def install
    system 'make'
    prefix.install 'bin'
    doc.install %w[README.md RELEASE_HISTORY]
  end

  test do
    system 'bedtools --version'
  end
end
