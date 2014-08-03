require 'formula'

class Mrfast < Formula
  homepage 'http://mrfast.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mrfast/mrfast/mrfast-2.6.0.1.tar.gz'
  sha256 '8635a217a91dcc1d16a21d4ad34898bd4e9a0080cc101f9cf7c28b172db31e8b'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=-c #{ENV.cflags}"
    bin.install 'mrfast'
  end

  test do
    actual = `#{bin}/mrfast -h`.split("\n").first
    expect = "mrFAST : Micro-Read Fast Alignment Search Tool."
    expect.eql? actual
  end
end
