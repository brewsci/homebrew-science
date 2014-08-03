require 'formula'

class Bpel2owfn < Formula
  homepage 'http://www.gnu.org/software/bpel2owfn'
  url 'http://download.gna.org/service-tech/bpel2owfn/bpel2owfn-2.4.tar.gz'
  sha1 '7917a990d0df53f9edd3a775063036b7a60d6e71'

  head do
    url 'http://svn.gna.org/svn/service-tech/trunk/bpel2owfn'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'flex' => :build
    depends_on 'bison' => :build
    depends_on 'gengetopt' => :build
    depends_on 'help2man' => :build
    depends_on 'kimwitu++' => :build
    depends_on 'gnu-sed' => :build
  end

  def install
    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bpel2owfn", "--help"
  end
end
