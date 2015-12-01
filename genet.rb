class Genet < Formula
  homepage "http://www.lsi.upc.edu/~jcarmona/genet.html"
  url "http://download.gna.org/service-tech/genet/genet-1.2.tar.gz"
  sha256 "29b95556686536102012c7374a66006bee37777b64d9d0d8d420e5c20bd004cf"

  head do
    url "http://svn.gna.org/svn/service-tech/trunk/genet"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt" => :build
    depends_on "help2man" => :build
  end

  def install
    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
