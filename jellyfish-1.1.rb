class Jellyfish11 < Formula
  homepage "http://www.cbcb.umd.edu/software/jellyfish/"
  #doi "10.1093/bioinformatics/btr011"
  #tag "bioinformatics"

  url "http://www.cbcb.umd.edu/software/jellyfish/jellyfish-1.1.11.tar.gz"
  sha256 "496645d96b08ba35db1f856d857a159798c73cbc1eccb852ef1b253d1678c8e2"

  bottle do
    cellar :any
    revision 1
    sha256 "719f8126dea0b27deeaf8fb720dcdea3820b5d61b28b07e13e86be0af9f738b1" => :yosemite
    sha256 "d649707ed054452a311d5f01bcf98bdff674801d4fb253f16abe18fe7940cc0a" => :mavericks
    sha256 "e5c6e3b53f473f31c44bdcbf9c8e04ac74f01199982dde27dc89d384a31630b8" => :mountain_lion
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
