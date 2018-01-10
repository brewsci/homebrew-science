class Jellyfish11 < Formula
  homepage "http://www.cbcb.umd.edu/software/jellyfish/"
  # doi "10.1093/bioinformatics/btr011"
  # tag "bioinformatics"

  url "http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.11.tar.gz"
  sha256 "496645d96b08ba35db1f856d857a159798c73cbc1eccb852ef1b253d1678c8e2"

  bottle do
    cellar :any
    rebuild 2
    sha256 "8c5a0090bb0cf7e57eaa5827a9080c393c242a28205f1b9cd0eac0142528f39a" => :el_capitan
    sha256 "698fbcc1a2d17f1f2b603ddf9c4c4e15aad4bddf15178b8f19ff2e4b0e46b6cf" => :yosemite
    sha256 "31c83eac99b4de298865103a122c2b3a8cd48d99aa0d7f78cc0a2472cd777b7b" => :mavericks
    sha256 "67d2aa432ca3859df00789504592b0e1e1b59af83fbd84ac41d96f5e75baebbd" => :x86_64_linux
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
