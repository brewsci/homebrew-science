class Lobstr < Formula
  desc "Profiles Short Tandem Repeats (STRs) from sequencing data"
  homepage "http://lobstr.teamerlich.org"
  url "https://github.com/mgymrek/lobstr-code/releases/download/v4.0.6/lobSTR-4.0.6.tar.gz"
  sha256 "f13bfc17eebd4aadd58fd798941318d8278a2da2e64e596027ebc26e004ce31c"
  revision 3
  # doi "10.1101/gr.135780.111"
  # tag "bioinformatics"

  bottle :disable, "needs to be rebuilt with latest boost"

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
