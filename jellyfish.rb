require "formula"

class Jellyfish < Formula
  homepage "http://www.genome.umd.edu/jellyfish.html"
  #doi "10.1093/bioinformatics/btr011"
  #tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/jellyfish/jellyfish-2.1.3.tar.gz"
  sha1 "b115dc7066cf24ab4026d8d8d429f094f3917cf2"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ebda78603c58f742b2c158e0f77a55a73fc1fcb9" => :yosemite
    sha1 "eaab1b21b747f6f252f9d5ec4c9a5fd6ed3e9d27" => :mavericks
  end

  #head "https://github.com/gmarcais/Jellyfish.git"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
