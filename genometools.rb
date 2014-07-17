require "formula"

class Genometools < Formula
  homepage "http://genometools.org/"
  #doi "10.1109/TCBB.2013.68"
  url "http://genometools.org/pub/genometools-1.5.3.tar.gz"
  sha1 "aa2bd8e2fe7ca274d7c9aecda6f23ab6547d935a"
  head "https://github.com/genometools/genometools.git"

  option :universal
  option 'with-check', "Run tests which require approximately one hour to run"
  option 'without-pangocairo', 'Build without Pango/Cairo (disables AnnotationSketch tool)'
  option 'with-hmmer', 'Build with HMMER (to enable protein domain search functionality in the ltrdigest tool)'

  depends_on "pkg-config" => :build

  if build.with? "pangocairo"
    depends_on "cairo"
    depends_on "pango"
  end

  def install
    args = ["prefix=#{prefix}"]
    args << "cairo=no" if build.without? "pangocairo"
    args << 'with-hmmer=yes' if build.with? 'hmmer'
    args << 'universal=yes' if build.universal?
    args << '64bit=yes' if MacOS.prefer_64_bit?

    system 'make', *args
    system 'make', 'test', *args if build.with? 'check'
    system 'make', 'install', *args

    (share/'genometools').install bin/'gtdata'
  end

  test do
    system "#{bin}/gt -test"
  end
end
