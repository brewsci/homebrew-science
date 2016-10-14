class Sara < Formula
  desc "Reachability analysis in petri nets"
  homepage "http://service-technology.org/sara"
  url "http://download.gna.org/service-tech/sara/sara-1.13.tar.gz"
  sha256 "2e1a616b6398bfc898b6a53aab16ef556ad59263b3ab71620592f83c43cd28ca"

  head do
    url "http://svn.gna.org/svn/service-tech/trunk/sara"
    depends_on "gengetopt" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "perform build-time checks"
  deprecated_option "without-check" => "without-test"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.deparallelize

    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--without-pnapi",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
