class SigrokCli < Formula
  homepage "http://sigrok.org/"
  url "http://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.5.0.tar.gz"
  sha256 "73a30501525b13c09624ae00d37041cdaa50238d89c6febf169fc784affe723c"

  head do
    url "git://sigrok.org/sigrok-cli", shallow: false
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
