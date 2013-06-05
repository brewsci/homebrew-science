require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/bio-bwa/bwa-0.7.5a.tar.bz2'
  sha1 '3ba4a2df24dc2a2578fb399dc77b3c240a5a18be'

  head 'https://github.com/lh3/bwa.git'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    man1.install "bwa.1"
  end
end
