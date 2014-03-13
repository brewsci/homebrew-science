require 'formula'

class Bowtie2 < Formula
  homepage 'http://bowtie-bio.sourceforge.net/bowtie2/index.shtml'
  url 'https://github.com/BenLangmead/bowtie2/archive/v2.2.1.tar.gz'
  sha256 'b8561370bc472f14471fff8dd478f225c52f910c0836ad76bf917e2cd538320a'
  head 'https://github.com/BenLangmead/bowtie2.git'

  def install
    system "make"
    bin.install %w[bowtie2 bowtie2-align-l bowtie2-align-s
      bowtie2-build bowtie2-build-l bowtie2-build-s
      bowtie2-inspect bowtie2-inspect-l bowtie2-inspect-s]
    doc.install %w[AUTHORS LICENSE MANUAL MANUAL.markdown NEWS README
      TUTORIAL VERSION]
  end

  def test
    system "bowtie2", "--version"
  end
end
