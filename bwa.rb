require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  url 'https://downloads.sf.net/project/bio-bwa/bwa-0.7.8.tar.bz2'
  sha1 'cb63f7865b4b043c11ecf5082724d52576ee784e'

  head 'https://github.com/lh3/bwa.git'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "bwa"
    doc.install %w[README.md NEWS]
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write "MEEPQSDPSV"
    system "#{bin}/bwa index test.fasta"
    assert File.exist?("test.fasta.bwt")
  end
end
