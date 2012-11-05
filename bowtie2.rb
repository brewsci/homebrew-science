require 'formula'

class Bowtie2 < Formula
  homepage 'http://bowtie-bio.sourceforge.net/bowtie2/index.shtml'
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.0.2/bowtie2-2.0.2-source.zip'
  sha1 'b310061a3ff265c386cea6f838e0bafa0268f0b8'

  def install
    system "make"
    bin.install %W(bowtie2 bowtie2-align bowtie2-build bowtie2-inspect)
  end

  def test
    system "bowtie2", "--version"
  end
end
