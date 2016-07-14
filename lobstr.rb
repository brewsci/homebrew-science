class Lobstr < Formula
  desc "Profiles Short Tandem Repeats (STRs) from sequencing data"
  homepage "http://lobstr.teamerlich.org"
  url "https://github.com/mgymrek/lobstr-code/releases/download/v4.0.6/lobSTR-4.0.6.tar.gz"
  sha256 "f13bfc17eebd4aadd58fd798941318d8278a2da2e64e596027ebc26e004ce31c"

  bottle do
    cellar :any
    sha256 "7026c87999258f045bf2696e11459fea2397c5b2037248b1f62d7e80ced60dd9" => :el_capitan
    sha256 "7589320083c7fcbf2a05d1ad68247312de85120d62663c6db75755c3cfbfcca1" => :yosemite
    sha256 "2e0aae1cc93cdf0d332969bfcb055c8e417ebe3f01314f59e338151b2211dc7b" => :mavericks
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
