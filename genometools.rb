class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # doi "10.1109/TCBB.2013.68"
  # tag "bioinformatics"
  url "http://genometools.org/pub/genometools-1.5.6.tar.gz"
  sha256 "f0dce0ba75fe7c74c278651c52ec716485bb2dd1cbb197ec38e13f239aace61c"
  head "https://github.com/genometools/genometools.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "ee67c68ce596c7c2436fd2dabb93560ae132a256aab5a104d34e5cae36cc7802" => :yosemite
    sha256 "9194816db5777b9054d5d6f3335540670d07fd5808a4067d118d9e20c77179a7" => :mavericks
    sha256 "0d2493080712493c0d7fe7550d41dccca78cb36ae4493b1bec4a9eb6cd258cdd" => :mountain_lion
  end

  option :universal
  option "with-check", "Run tests which require approximately one hour to run"
  option "without-pangocairo", "Build without Pango/Cairo (disables AnnotationSketch tool)"
  option "with-hmmer", "Build with HMMER (to enable protein domain search functionality in the ltrdigest tool)"

  depends_on "pkg-config" => :build

  if build.with? "pangocairo"
    depends_on "cairo"
    depends_on "pango"
  end

  def install
    args = ["prefix=#{prefix}"]
    args << "cairo=no" if build.without? "pangocairo"
    args << "with-hmmer=yes" if build.with? "hmmer"
    args << "universal=yes" if build.universal?
    args << "64bit=yes" if MacOS.prefer_64_bit?

    system "make", *args
    system "make", "test", *args if build.with? "check"
    system "make", "install", *args

    (share/"genometools").install bin/"gtdata"
  end

  test do
    system "#{bin}/gt", "-test"
  end
end
