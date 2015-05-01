class Genometools < Formula
  homepage "http://genometools.org/"
  # doi "10.1109/TCBB.2013.68"
  # tag "bioinformatics"
  url "http://genometools.org/pub/genometools-1.5.4.tar.gz"
  sha256 "42974626a53d78b1c0249c47e07584dce1c81b85bb880133fcf614e3358623d6"
  head "https://github.com/genometools/genometools.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "75e2acb15ddbce0bcb79a257dbcb1f10b91035b85dd0d438a67d720c93e63aaa" => :yosemite
    sha256 "6266345d69e24a6206499162fafdeea0b28f0e4dcfe55686ad6550de5b04bb2f" => :mavericks
    sha256 "e5000682daaa37e0f7d5ccda00ae966a56d4780c42aeed08146c29acd25bec0f" => :mountain_lion
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
