require 'formula'

class Bedtools < Formula
  homepage 'https://github.com/arq5x/bedtools2'
  url 'https://github.com/arq5x/bedtools2/archive/v2.18.2.tar.gz'
  sha1 'eaecc3841cec23b9dbc06e205d8dd2838525f1b5'
  head 'https://github.com/arq5x/bedtools2.git'

  def install
    system 'make'
    prefix.install 'bin'
    doc.install %w[README.rst RELEASE_HISTORY]
  end

  test do
    system 'bedtools --version'
  end
end
