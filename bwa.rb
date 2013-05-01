require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.4.tar.bz2'
  sha1 '1a23895b330140cf73484b1a9fb4d3bf83ff3e8b'

  head 'https://github.com/lh3/bwa.git'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    man1.install "bwa.1"
  end
end
