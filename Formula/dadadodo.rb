class Dadadodo < Formula
  homepage "https://www.jwz.org/dadadodo/"
  url "https://www.jwz.org/dadadodo/dadadodo-1.04.tar.gz"
  sha256 "2e0ebb90951c46ff8823dfeca0c9402ce4576b31dd8bc4b2740a951aebb8fcdf"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}"
    bin.install "dadadodo"
  end
end
