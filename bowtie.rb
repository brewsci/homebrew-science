require 'formula'

class Bowtie < Formula
  homepage 'http://bowtie-bio.sourceforge.net/index.shtml'
  url 'https://downloads.sourceforge.net/project/bowtie-bio/bowtie/1.0.0/bowtie-1.0.0-src.zip'
  sha256 '51e434a78e053301f82ae56f4e94f71f97b19f7175324777a7305c8f88c5bac5'

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
