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
    revision 1
    sha256 "b3e1555202c919115e3c4fb6199f5062d3819894df6a74c76894a65af15c31de" => :yosemite
    sha256 "1b5bde3c8025a545a1f4b05c19cb8a9868bd2a736ef26e6688b199915fefe529" => :mavericks
    sha256 "22787830d70fdc4519aa9dd401293a7aaeeb98cddaab2e146fff1d33426f954b" => :mountain_lion
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

    prefix.install bin/"gtdata"
  end

  test do
    system "#{bin}/gt", "-test"
  end
end
