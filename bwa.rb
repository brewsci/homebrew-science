require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.3a.tar.bz2'
  sha1 '400df68b591413d86880a7f9924b278af39d34c6'

  head 'https://github.com/lh3/bwa.git'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    man1.install "bwa.1"
  end
end
