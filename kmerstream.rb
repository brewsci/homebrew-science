class Kmerstream < Formula
  homepage "https://github.com/pmelsted/KmerStream"
  # tag "bioinformatics"
  # doi "10.1101/003962"
  url "https://github.com/pmelsted/KmerStream/archive/v1.0.tar.gz"
  sha256 "65372515dc19fb30c89f912c4a8c302ee3b266e931bbb2983e232e1c9ea62efe"
  head "https://github.com/pmelsted/KmerStream.git"

  needs :openmp

  def install
    system "make"
    bin.install "KmerStream"
  end

  test do
    system "#{bin}/KmerStream 2>&1 |grep KmerStream"
  end
end
