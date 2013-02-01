require 'formula'

class Fastqc < Formula
  homepage 'http://www.bioinformatics.babraham.ac.uk/projects/fastqc/'
  url 'http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.10.1.zip'
  sha1 'd1d9c1489c46458614fcedcbbb30e799a0e796a2'

  def install
    chmod 0755, 'fastqc'
    prefix.install Dir['*']
    mkdir_p bin
    ln_s prefix/'fastqc', bin/'fastqc'
  end

  def test
    system "fastqc", "-h"
  end
end
