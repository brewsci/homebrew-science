class Lola < Formula
  homepage "http://service-technology.org/lola/"
  url "http://download.gna.org/service-tech/lola/lola-2.0.tar.gz"
  sha256 "9c39f77b6f8a9a972cd380fcefe7c245ba040caa68e7772f85b8dbcbd79ba757"

  option "with-check", "Run build-time tests"

  head do
    url "http://svn.gna.org/svn/service-tech/trunk/lola2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "flex" => :build
    depends_on "bison" => :build
    depends_on "gengetopt" => :build
    depends_on "help2man" => :build
    depends_on "kimwitu++" => :build
    depends_on "gnu-sed" => :build
  end

  depends_on "autoconf" if build.with? "check"

  def install
    ENV.deparallelize

    system "autoreconf -i" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check" if build.with? "check"
  end
end
