class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # doi "10.1109/TCBB.2013.68"
  # tag "bioinformatics"
  url "http://genometools.org/pub/genometools-1.5.6.tar.gz"
  sha256 "f0dce0ba75fe7c74c278651c52ec716485bb2dd1cbb197ec38e13f239aace61c"
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    revision 2
    sha256 "4fc4414aab0218b0339e9be0df71819ac848b71a26142722cb8e585143427fbb" => :yosemite
    sha256 "23b1f6321e853427cef823ae43b3f531bdd3837231229e2cc29790f3a7d4a7c8" => :mavericks
    sha256 "312b6bc4255448db7ce2953d46400da4aaf3da8a9d20d6dff66bdf5288ec9871" => :mountain_lion
  end

  option :universal
  option "with-check", "Run tests which require approximately one hour to run"
  option "without-pangocairo", "Build without Pango/Cairo (disables AnnotationSketch tool)"
  option "with-hmmer", "Build with HMMER (to enable protein domain search functionality in the ltrdigest tool)"

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
    args << "universal=yes" if build.universal?
    args << "64bit=yes" if MacOS.prefer_64_bit?

    system "make", *args
    system "make", "test", *args if build.with? "check"
    system "make", "install", *args

    prefix.install bin/"gtdata"

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
