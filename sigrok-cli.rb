class SigrokCli < Formula
  desc "Command-line client for sigrok"
  homepage "https://sigrok.org/"
  url "https://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.7.0.tar.gz"
  sha256 "5669d968c2de3dfc6adfda76e83789b6ba76368407c832438cef5e7099a65e1c"

  bottle do
    cellar :any
    sha256 "a41bd3e0acc877ec54a8019cf2b7640834eb7d531b6bb74c3d4bf345cd58360a" => :sierra
    sha256 "50a9411021aa97979f58857e08a1f11034e0fadf52ca901dac0ab5b9deaa7a22" => :el_capitan
    sha256 "68ad9e7ecba9e55ad3ba1d8810fefdc57d1327a300ce45ca76d4745fa7e6505d" => :yosemite
    sha256 "daa914ca934055c095efefe16a6db86d7714e2e1e0d45b3c4641ec51220102b5" => :x86_64_linux
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
