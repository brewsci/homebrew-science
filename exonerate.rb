class Exonerate < Formula
  homepage "http://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate"
  #doi "10.1186/1471-2105-6-31"
  #tag "bioinformatics"
  url "http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/exonerate-2.2.0.tar.gz"
  sha256 "0ea2720b1388fa329f889522f43029b416ae311f57b229129a65e779616fe5ff"

  bottle do
    revision 1
    sha256 "35a5e092287ec175496d893e931e933aff70e5a18c5872580442593f87986b23" => :yosemite
    sha256 "4ddaa4cb9bc60530797cdc8f0b738c118c0ba556fc6042999d7fdbc615153c0e" => :mavericks
    sha256 "a99061bb8a28b889a88a7ca02f91180c0d44a552c1dd4891776ad5632792aea5" => :mountain_lion
  end

  devel do
    url "http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/exonerate-2.4.0.tar.gz"
    sha256 "f849261dc7c97ef1f15f222e955b0d3daf994ec13c9db7766f1ac7e77baa4042"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    # Fix the following error. This issue is fixed upstream in 2.4.0.
    # /usr/bin/ld: socket.o: undefined reference to symbol 'pthread_create@@GLIBC_2.2.5'
    # /lib/x86_64-linux-gnu/libpthread.so.0: error adding symbols: DSO missing from command line
    inreplace "configure", 'LDFLAGS="$LDFLAGS -lpthread"', 'LIBS="$LIBS -lpthread"' unless build.devel?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/exonerate --version |grep exonerate"
  end
end
