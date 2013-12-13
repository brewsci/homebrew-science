require 'formula'

class Bedtools < Formula
  homepage 'https://github.com/arq5x/bedtools2'
  url 'https://github.com/arq5x/bedtools2/archive/v2.18.0.tar.gz'
  sha1 'd0cbe30d0d2be4dbda89d81f72189319f0e798e5'
  head 'https://github.com/arq5x/bedtools2.git'

  fails_with :clang do
    # Reported upstream: https://github.com/arq5x/bedtools2/issues/2
    build 500
    cause "error: declaration of 'T' shadows template parameter"
  end

  def install
    system 'make'
    prefix.install 'bin'
    doc.install %w[README.rst RELEASE_HISTORY]
  end

  test do
    system 'bedtools --version'
  end
end
