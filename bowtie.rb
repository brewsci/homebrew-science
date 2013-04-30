require 'formula'

class Bowtie < Formula
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  url 'http://downloads.sourceforge.net/project/bowtie-bio/bowtie/1.0.0/bowtie-1.0.0-src.zip'
  sha256 '51e434a78e053301f82ae56f4e94f71f97b19f7175324777a7305c8f88c5bac5'

  head 'https://github.com/BenLangmead/bowtie.git'

  def install
    system "make"
    bin.install %W(bowtie bowtie-build bowtie-inspect)
  end

  def test
    system "bowtie", "--version"
  end
end
