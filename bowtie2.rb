require 'formula'

class Bowtie2 < Formula
  homepage "http://bowtie-bio.sourceforge.net/bowtie2/index.shtml"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.2.2.tar.gz"
  sha1 "7cccb06ee9e57e9566b0bb0fce4b9a3d01d0ffd7"
  head "https://github.com/BenLangmead/bowtie2.git"

  def install
    system "make"
    bin.install %W[bowtie2
                   bowtie2-align-l bowtie2-align-s
                   bowtie2-build   bowtie2-build-l   bowtie2-build-s
                   bowtie2-inspect bowtie2-inspect-l bowtie2-inspect-s]

    doc.install %W[AUTHORS LICENSE MANUAL
                   NEWS README TUTORIAL VERSION]
  end

  def test
    system "bowtie2", "--version"
  end
end
