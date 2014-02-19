require 'formula'

class Lola < Formula
  homepage 'http://www.informatik.uni-rostock.de/tpp/lola/'
  url 'http://download.gna.org/service-tech/lola/lola-1.17.tar.gz'
  sha1 '05e45e46f2fb2681ef369c2fd63f88115a912c55'

  head do
    url 'http://svn.gna.org/svn/service-tech/trunk/lola'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'flex' => :build
    depends_on 'bison' => :build
    depends_on 'gengetopt' => :build
    depends_on 'help2man' => :build
  end

  def install
    ENV.deparallelize

    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" if build.head?
    system "make", "clean" if build.head?
    system "make", "all-configs"
    system "make", "install"
  end
end
