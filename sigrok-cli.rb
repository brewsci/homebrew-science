class SigrokCli < Formula
  desc "Command-line client for sigrok"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.7.0.tar.gz"
  sha256 "5669d968c2de3dfc6adfda76e83789b6ba76368407c832438cef5e7099a65e1c"

  bottle do
    cellar :any
    sha256 "5d8e6a75e4b59ddbff563cfb679fa086b59285e4dce385c5b71e362b1ce8f8b4" => :sierra
    sha256 "25dd3a07147e5ad984236cd6823182ee1ad6c32851eed2b08732ed24d042946e" => :el_capitan
    sha256 "79d672aba4fa67b2ff2c68a1650ff6f258c88c9b738b20417157d96c39f31e99" => :yosemite
  end

  head do
    url "git://sigrok.org/sigrok-cli", :shallow => false
    depends_on "glib"
    depends_on "libtool" => :build unless OS.mac?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
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
