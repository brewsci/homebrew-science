require 'formula'

class Bowtie2 < Formula
  homepage 'http://bowtie-bio.sourceforge.net/bowtie2/index.shtml'
  url 'https://github.com/BenLangmead/bowtie2/archive/v2.2.0.tar.gz'
  sha256 '256ef9dcf13ed14e54c23a98e4019bb41399501c7b92dd4eb36bea8e5954fdc9'
  head 'https://github.com/BenLangmead/bowtie2.git'

  def patches
    # Handle bowtie2 being a relative symlink. Reported upstream:
    # https://github.com/BenLangmead/bowtie2/pull/3
    'https://github.com/sjackman/bowtie2/commit/3c3ef74afd4984b5506a19445c6a8b1cdfbc1f42.patch'
  end unless build.head?

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
