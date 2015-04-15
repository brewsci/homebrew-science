class Libsequence < Formula
  homepage "https://molpopgen.github.io/libsequence/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btg316"
  url "https://github.com/molpopgen/libsequence/archive/1.8.4.tar.gz"
  sha1 "1cac19fffad293309c834f3f356023c990422988"
  head "https://github.com/molpopgen/libsequence.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "2ddee49b6d9cac4d864fc9703f0883b562ae2e0a0e0687de47699ae1d8cf772e" => :yosemite
    sha256 "d3734a60eece746f0e72bc58275350ed196c55dd1fe12000a74738a14547b3a7" => :mavericks
  end

  depends_on :macos => :mavericks
  depends_on "boost" => :build
  depends_on "gsl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--docdir=#{doc}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
