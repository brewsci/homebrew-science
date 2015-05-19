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
    sha256 "cb8a169582b5d2916b2ab87ea8da8d52b13f84f7801f45bc8d9e972ffea33b23" => :yosemite
    sha256 "ab7656573d0c74c49ae7070bb00bf802a590695365c0e2e380ed90db5a4254fa" => :mavericks
    sha256 "3effd88b8de554f112e2358042f0f791c9f387495dfbff3a4dd75e7c5419adf4" => :mountain_lion
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
