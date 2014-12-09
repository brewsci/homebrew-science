require "formula"

class SigrokCli < Formula
  homepage "http://sigrok.org/"
  url "http://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.5.0.tar.gz"
  sha1 "6fb5d6ff75f6492bca8d3da66ba446a6438438de"

  head do
    url "git://sigrok.org/sigrok-cli", :shallow => false
    depends_on "glib"
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build

  depends_on "libsigrokdecode"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV.delete "PYTHONPATH"
    system "#{bin}/sigrok-cli", "--version"
  end
end
