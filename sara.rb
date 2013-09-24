require 'formula'

class Sara < Formula
  homepage 'http://service-technology.org/sara'
  head 'http://svn.gna.org/svn/service-tech/trunk/sara'
  url 'http://download.gna.org/service-tech/sara/sara-1.13.tar.gz'
  sha1 'a4f03cc3ffc73613610ecce4c6b6a60b1a94171d'

  depends_on 'autoconf' if build.head?
  depends_on 'automake' if build.head?
  depends_on 'gengetopt' if build.head?
  depends_on 'help2man' if build.head?
  depends_on 'libtool' if build.head?

  option "without-check", "skip build-time checks (not recommended)"

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
