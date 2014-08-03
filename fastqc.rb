require 'formula'

class Fastqc < Formula
  homepage 'http://www.bioinformatics.babraham.ac.uk/projects/fastqc/'
  url 'http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.2.zip'
  sha1 'd4dc1b903de35aa4de8e995c4974e0869db99dda'

  def install
    chmod 0755, 'fastqc'
    prefix.install Dir['*']
    mkdir_p bin
    ln_s prefix/'fastqc', bin/'fastqc'
  end

  test do
    system "fastqc", "-h"
  end
end
