require 'formula'

class Bowtie2 < Formula
  homepage 'http://bowtie-bio.sourceforge.net/bowtie2/index.shtml'
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.0.5/bowtie2-2.0.5-source.zip'
  sha1 '2f0cc813abec0e297e728352e350b561aff95347'

  def install
    system "make"
    bin.install %W(bowtie2 bowtie2-align bowtie2-build bowtie2-inspect)
  end

  def test
    system "bowtie2", "--version"
  end
end
