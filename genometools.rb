class Genometools < Formula
  desc "GenomeTools: The versatile open source genome analysis software"
  homepage "http://genometools.org/"
  # doi "10.1109/TCBB.2013.68"
  # tag "bioinformatics"
  url "http://genometools.org/pub/genometools-1.5.9.tar.gz"
  sha256 "36923198a4214422886fd1425ef986bd7e558c73b94194982431cfd3dc7eb387"
  head "https://github.com/genometools/genometools.git"

  bottle do
    cellar :any
    sha256 "94362afb9cc048a3b26a3ee8731c9fc75e15b74bf165c10eb9826acf45419738" => :el_capitan
    sha256 "4bc79c22e52962a18051aabaf9dcf86681847abbf3f8430ca79075bce0047dbf" => :yosemite
    sha256 "b432b847a18e0e76cf861b7fed9c814d0b214a6667fc9f40d719fec5985df3fb" => :mavericks
    sha256 "511e0711954994632f5539fc59b7deb09b221c980b3065d9923f240be8b00051" => :x86_64_linux
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
