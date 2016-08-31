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
    sha256 "6d1ec738059879b19e22d04c93739dff1b0f9ca85cc3d997e6150df8f903a536" => :el_capitan
    sha256 "1d0d246f91f2f84b32d8bd72c0828dc571f5731ce2afcbf0b3c6a258a857b738" => :yosemite
    sha256 "58e3fcfc4d6b23975cb8c688ebc84e5a4d690ab1f1d0061161e3edc55f178a02" => :mavericks
    sha256 "cd629d2883ce666b1ceef041beb36228da987137a186cddc718b13d7f05f2397" => :x86_64_linux
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
