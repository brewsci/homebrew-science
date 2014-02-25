require 'formula'

class Bwa < Formula
  homepage 'http://bio-bwa.sourceforge.net/'
  url 'https://github.com/lh3/bwa/archive/0.7.7.tar.gz'
  sha1 '3b22dc42aad136a4373fcd36e7e162a0482df329'

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
