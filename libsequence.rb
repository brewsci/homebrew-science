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
    revision 2
    sha256 "3488ce470dd77c1bb26cd28d2104393de35a8c780ad89e83f499ec5b59813c87" => :yosemite
    sha256 "6ba89329001cdacc6434016f78d1053e760a1468363b98e1b8b553205bc850a6" => :mavericks
    sha256 "a1d89ba3fa084506185ed5842b6a8b5709281591178a9a3df414edb22d459463" => :mountain_lion
  end

  cxx11 = OS.linux? || MacOS.version > :mountain_lion ? [] : ["c++11"]

  depends_on "boost" => cxx11
  depends_on "gsl"

  needs :cxx11

  def install
    ENV.cxx11
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
