require "formula"

class Jellyfish < Formula
  homepage "http://www.genome.umd.edu/jellyfish.html"
  url "ftp://ftp.genome.umd.edu/pub/jellyfish/jellyfish-2.1.3.tar.gz"
  sha1 "b115dc7066cf24ab4026d8d8d429f094f3917cf2"

  #head "https://github.com/gmarcais/Jellyfish.git"
  #doi "10.1093/bioinformatics/btr011"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
