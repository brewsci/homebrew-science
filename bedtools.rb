require 'formula'

class Bedtools < Formula
  homepage 'https://github.com/arq5x/bedtools2'
  url 'https://github.com/arq5x/bedtools2/releases/download/v2.19.1/bedtools-2.19.1.tar.gz'
  sha1 '7a9027d7992ae399cde8fb7dab520b332605740c'
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
