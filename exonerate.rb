require 'formula'

class Exonerate < Formula
  homepage 'http://www.ebi.ac.uk/~guy/exonerate/'
  #doi '10.1186/1471-2105-6-31'
  #tag "bioinformatics"
  url 'http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.2.0.tar.gz'
  sha1 'ad4de207511e4d421e5cc28dda2261421c515bf0'

  devel do
    url "http://www.ebi.ac.uk/~guy/exonerate/exonerate-2.4.0.tar.gz"
    sha1 "5b119c0aef0fa08c3f4a11014544f2ac5ca8afde"
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    # Fix the following error. This issue is fixed upstream in 2.4.0.
    # /usr/bin/ld: socket.o: undefined reference to symbol 'pthread_create@@GLIBC_2.2.5'
    # /lib/x86_64-linux-gnu/libpthread.so.0: error adding symbols: DSO missing from command line
    inreplace "configure", 'LDFLAGS="$LDFLAGS -lpthread"', 'LIBS="$LIBS -lpthread"' unless build.devel?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/exonerate --version |grep exonerate"
  end
end
