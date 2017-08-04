class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # doi "10.1109/TCBB.2013.68"
  # tag "bioinformatics"
  url "http://genometools.org/pub/genometools-1.5.10.tar.gz"
  sha256 "0208591333b74594bc219fb67f5a29b81bb2ab872f540c408ac1743716274e6a"
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "6b666d728c5f7a987b9e5a1a661e5474fab541331dfc437e65a1ac8bd703d42f" => :sierra
    sha256 "9e84b5828a349fd5f1d593a7787b2c13b61cb7ed79bafdb0da3c33cdb0a0c01d" => :el_capitan
    sha256 "4134e5f124484f31c55c661e05f0ec413b3cff8cd2a380bef4c495110dbca1ee" => :yosemite
    sha256 "e40fe8bbd868eb1f5846e5fffaf4e5255cd80ded39304a9448d55eae04dbe9ee" => :x86_64_linux
  end

  option "with-test", "Run tests which require approximately one hour to run"
  option "without-pangocairo", "Build without Pango/Cairo (disables AnnotationSketch tool)"
  option "with-hmmer", "Build with HMMER (to enable protein domain search functionality in the ltrdigest tool)"

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on :python => :recommended unless OS.mac? && MacOS.version >= :lion

  if build.with? "pangocairo"
    depends_on "cairo"
    depends_on "pango"
  end

  def install
    args = ["prefix=#{prefix}"]
    args << "cairo=no" if build.without? "pangocairo"
    args << "with-hmmer=yes" if build.with? "hmmer"
    args << "64bit=yes" if MacOS.prefer_64_bit?

    system "make", *args
    system "make", "test", *args if build.with? "test"
    system "make", "install", *args

    if build.with? "python"
      cd "gtpython" do
        inreplace "gt/dlload.py", "gtlib = CDLL(\"libgenometools\" + soext)", "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"
        system "python", *Language::Python.setup_install_args(prefix)
        system "python", "-m", "unittest", "discover", "tests"
      end
    end
  end

  test do
    system "#{bin}/gt", "-test"
    system "python", "-c", "from gt import *" if build.with? "python"
  end
end
