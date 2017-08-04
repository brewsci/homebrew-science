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
    sha256 "88728e10c788d91a1fd24b8d754b0c21b6db481339c010a6b0c57f6a7375003b" => :sierra
    sha256 "159f065b370710aed255ec8af4f0512908fb9814b0b9a0d7c5d9b8d178306c00" => :el_capitan
    sha256 "9753ed6a87377efb3bd6e824ff2aebffd641cb8991aba133ef43e92d18474b4f" => :yosemite
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
