require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  #doi '10.1093/bioinformatics/btp324'
  url 'https://downloads.sf.net/project/bio-bwa/bwa-0.7.9a.tar.bz2'
  sha1 'a77ce327e8acba554b1d27bfdd1c148f79726484'

  head 'https://github.com/lh3/bwa.git'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    doc.install %w[README.md NEWS.md]
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write "MEEPQSDPSV"
    system "#{bin}/bwa index test.fasta"
    assert File.exist?("test.fasta.bwt")
  end
end
