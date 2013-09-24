require 'formula'

class Pnapi < Formula
  homepage 'http://service-technology.org/pnapi/'
  head 'http://svn.gna.org/svn/service-tech/trunk/pnapi'
  url 'http://download.gna.org/service-tech/pnapi/pnapi-4.03.tar.gz'
  sha1 'd054018c4a2e580add680ffac28731461cf9e308'

  option "without-check", "skip build-time checks (not recommended)"

  depends_on "graphviz"
  depends_on "lola"
  depends_on 'pkg-config' => :build
  depends_on "genet" => :optional
  if build.head?
    depends_on 'autoconf'
    depends_on 'automake'
    depends_on 'gengetopt'
    depends_on 'help2man'
    depends_on 'gnu-sed'
    depends_on 'libtool'
  end

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

  def test
    system "#{bin}/petri", "--help"
  end
end
