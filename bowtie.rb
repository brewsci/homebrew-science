require 'formula'

class Bowtie < Formula
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie/0.12.9/bowtie-0.12.9-src.zip'
  sha1 'ce261d82695e6e97ffc1bc9c3f6651a9fbb2feba'

  def install
    system "make"
    bin.install %W(bowtie bowtie-build bowtie-inspect)
  end

  def test
    system "bowtie", "--version"
  end
end
