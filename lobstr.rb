class Lobstr < Formula
  desc "Profiles Short Tandem Repeats (STRs) from sequencing data"
  homepage "http://lobstr.teamerlich.org"
  url "https://github.com/mgymrek/lobstr-code/releases/download/v4.0.6/lobSTR-4.0.6.tar.gz"
  sha256 "f13bfc17eebd4aadd58fd798941318d8278a2da2e64e596027ebc26e004ce31c"
  revision 2
  # doi "10.1101/gr.135780.111"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "d7358fd7b7bc1753c94b7b7d96c1cdedd80b71d600caed576f8dcd072cc76287" => :el_capitan
    sha256 "c5c3b7e8f8d4be75fc313335b86bf2bd23ee25348ae0b13c271524a87e33ee69" => :yosemite
    sha256 "9807d22a6e867e6e5acf465f489bf6b8e4958f3de9c12ebd09a9960bc30dda9d" => :mavericks
    sha256 "4d4d4fac3e79836e4a89dd9d0269d7cd987332c8613cbc904ab4aa384c42b8a7" => :x86_64_linux
  end

  head do
    url "https://github.com/mgymrek/lobstr-code.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "without-test", "Disable build-time checking (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cppunit" => :build
  depends_on "gsl"
  depends_on "boost"

  def install
    system "sh", "./reconf" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    args = %W[
      --verbose
      --index-prefix #{share}/lobSTR/test-ref/lobSTR_
      --fastq
      -f #{share}/lobSTR/sample/tiny.fq
      --rg-sample test
      --rg-lib test
      --out test
    ]
    system bin/"lobSTR", *args
    assert File.exist? "test.aligned.bam"
    assert File.exist? "test.aligned.stats"
  end
end
