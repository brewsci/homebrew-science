require "formula"

class Kmerstream < Formula
  homepage "https://github.com/pmelsted/KmerStream"
  #doi "10.1101/003962"
  head "https://github.com/pmelsted/KmerStream.git"

  url "https://github.com/pmelsted/KmerStream/archive/v1.0.tar.gz"
  sha1 "97688502c15c2b7457054aaf8e8a8f07f4fd159b"

  fails_with :clang do
    build 600
    cause "Requires OpenMP"
  end

  def install
    system "make"
    bin.install "KmerStream"
  end

  test do
    system "#{bin}/KmerStream 2>&1 |grep KmerStream"
  end
end
