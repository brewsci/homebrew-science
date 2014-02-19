require 'formula'

class Genet < Formula
  homepage 'http://www.lsi.upc.edu/~jcarmona/genet.html'
  url 'http://download.gna.org/service-tech/genet/genet-1.2.tar.gz'
  sha1 '3daa288ee932c502b79bbe44d0ce55f12994b099'

  head do
    url 'http://svn.gna.org/svn/service-tech/trunk/genet'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
    depends_on 'gengetopt' => :build
    depends_on 'help2man' => :build
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
