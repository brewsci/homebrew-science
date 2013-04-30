require 'formula'

class Bowtie2 < Formula
  homepage 'http://bowtie-bio.sourceforge.net/bowtie2/index.shtml'
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.1.0/bowtie2-2.1.0-source.zip'
  sha256 '90a9d3a6bd19ddc3a8f90b935c6a2288478572de2ad4039b29f91016b95ef4b0'

  def install
    system "make"
    bin.install %W(bowtie2 bowtie2-align bowtie2-build bowtie2-inspect)
  end

  def test
    system "bowtie2", "--version"
  end
end
