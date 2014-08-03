require 'formula'

class Pnapi < Formula
  homepage 'http://service-technology.org/pnapi/'
  url 'http://download.gna.org/service-tech/pnapi/pnapi-4.03.tar.gz'
  sha1 'd054018c4a2e580add680ffac28731461cf9e308'

  head do
    url "http://svn.gna.org/svn/service-tech/trunk/pnapi"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt" => :build
    depends_on "help2man" => :build
    depends_on "gnu-sed" => :build
  end

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "graphviz"
  depends_on "lola"
  depends_on 'pkg-config' => :build
  depends_on "genet" => :optional

  def install
    ENV.deparallelize if build.head?

    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check" if build.with? "check"
    # for some reason config.h is not installed by the Makefile
    (include/'pnapi').install 'src/config.h'
  end

  test do
    system "#{bin}/petri", "--help"
  end
end
