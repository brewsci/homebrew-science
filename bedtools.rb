require 'formula'

class Bedtools < Formula
  homepage 'https://github.com/arq5x/bedtools2'
  url 'https://github.com/arq5x/bedtools2/archive/v2.18.1.tar.gz'
  sha1 'ce7c1ca7ca3717f77e4260eee83e22dab9dfdd87'
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
