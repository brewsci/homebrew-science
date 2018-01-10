class Pnapi < Formula
  desc "C++ library encapsulating Petri net-related functions"
  homepage "http://home.gna.org/service-tech/pnapi"
  url "http://download.gna.org/service-tech/pnapi/pnapi-4.03.tar.gz"
  sha256 "2235be39b1c0615ded0197e57661a5127337681f034a8d29bed833f376c8a836"

  bottle do
    sha256 "96f1232332d350e2a5fd55bcf040ba88b500b6bdb13cfa322ec37d43e4e38732" => :sierra
    sha256 "6cc3c17d3f75c12c7785b67be26e0ae9f7c3d1a26a17455ee7bc56af0e21c53d" => :el_capitan
    sha256 "bdf20541df9f3af23277e207715654c1905de28b44e63771de10741e57312511" => :yosemite
  end

  head do
    url "http://svn.gna.org/svn/service-tech/trunk/pnapi"
    depends_on "libtool" => :build
    depends_on "gengetopt" => :build
    depends_on "help2man" => :build
    depends_on "gnu-sed" => :build
  end

  option "with-test", "perform build-time checks"
  deprecated_option "with-check" => "with-test"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "graphviz"
  depends_on "lola"
  depends_on "pkg-config" => :build
  depends_on "genet" => :optional

  def install
    ENV.deparallelize if build.head?

    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check" if build.with? "test"
    # for some reason config.h is not installed by the Makefile
    (include/"pnapi").install "src/config.h"
  end

  test do
    system "#{bin}/petri", "--help"
  end
end
