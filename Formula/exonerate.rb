class Exonerate < Formula
  desc "Pairwise sequence alignment of DNA and proteins"
  homepage "https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate"
  # doi "10.1186/1471-2105-6-31"
  # tag "bioinformatics"
  url "http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/exonerate-2.2.0.tar.gz"
  sha256 "0ea2720b1388fa329f889522f43029b416ae311f57b229129a65e779616fe5ff"

  bottle do
    rebuild 2
    sha256 "0da7d050c4bc1f2c57a9eabbd72bd35701df4e24cc0284c5ef1f22488657873e" => :el_capitan
    sha256 "3980be24502af233551019f9aa7f96921042a9fc7077bc2b7cefd815edfc871c" => :yosemite
    sha256 "a1d6bdf2b7a5bb246e61a6c8c5e8ff288b061b2d183c451660f3fd8d4c497ba0" => :mavericks
    sha256 "1d1c62fd7e440ad60d6456f1ed472840d4274d25fb561a849d6e3f224146c615" => :x86_64_linux
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
