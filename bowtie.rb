require 'formula'

class Bowtie < Formula
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  url 'https://downloads.sourceforge.net/project/bowtie-bio/bowtie/1.0.1/bowtie-1.0.1-src.zip'
  sha256 '41f6022652c65a7896b8daf0507fd7626241fd2a87894a02bc6fd428d4d0b447'

  head 'https://github.com/BenLangmead/bowtie.git'

  fails_with :clang do
    build 503
    cause %q[error: reference to 'lock_guard' is ambiguous. See #476]
  end

  def install
    system 'make'
    bin.install %w[bowtie bowtie-build bowtie-inspect]
    doc.install %w[AUTHORS LICENSE MANUAL MANUAL.markdown NEWS TUTORIAL
      doc/manual.html]
    libexec.install Dir['scripts/*']
  end

  def test
    system *%w[bowtie --version]
  end
end
