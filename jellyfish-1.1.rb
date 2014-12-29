require "formula"

class Jellyfish11 < Formula
  homepage "http://www.cbcb.umd.edu/software/jellyfish/"
  #doi "10.1093/bioinformatics/btr011"
  #tag "bioinformatics"

  url "http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.11.tar.gz"
  sha1 "8bd6a7b382e94d37adfddd916dec2b0e36f840fd"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "b4b2ff85afb9eb9a01195cc18f57f9eeb95588f3" => :yosemite
    sha1 "3c50af45fa15a69b72ec34f012f406b7b866382f" => :mavericks
    sha1 "64ca4a63f5b5bd5d4d4f48705ea694b5925a3de7" => :mountain_lion
  end

  keg_only "It conflicts with jellyfish."

  fails_with :clang do
    cause "error: variable length array of non-POD element type"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jellyfish", "--version"
  end
end
