require 'formula'

class Bedtools < Formula
  homepage 'https://github.com/arq5x/bedtools2'
  url 'https://github.com/arq5x/bedtools2/releases/download/v2.19.0/bedtools-2.19.0.tar.gz'
  sha1 'f870c801ccc96a032f061db4d4a0c54f3ab46e64'
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
