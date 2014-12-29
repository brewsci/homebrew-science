require "formula"

class Exonerate < Formula
  homepage "http://www.ebi.ac.uk/~guy/exonerate/"
  #doi "10.1186/1471-2105-6-31"
  #tag "bioinformatics"
  url "http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.2.0.tar.gz"
  sha1 "ad4de207511e4d421e5cc28dda2261421c515bf0"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "dea2a01264de5d3b918afacdd01946960f12f75a" => :yosemite
    sha1 "c2a808a60fd9f77b7d09133b2a136a3d3af05b8d" => :mavericks
    sha1 "d337e9190f4cade5fabd3cc6ba4ce33ee1615e4b" => :mountain_lion
  end

  devel do
    url "http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.4.0.tar.gz"
    sha1 "5b119c0aef0fa08c3f4a11014544f2ac5ca8afde"
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
