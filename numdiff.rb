class Numdiff < Formula
  desc "Putative files comparison tool"
  homepage "http://www.nongnu.org/numdiff"
  url "http://mirror6.layerjet.com/nongnu//numdiff/numdiff-5.9.0.tar.gz"
  sha256 "87284a117944723eebbf077f857a0a114d818f8b5b54d289d59e73581194f5ef"

  bottle do
    sha256 "cffef8a28c7fd0fa994af0058b7792e0d80102b50a26d99c61cac6b88d2cec11" => :sierra
    sha256 "494b14d0ea41b2b5a4a5801958b5d51c926f04713f21079fc3b74480f1b941bb" => :el_capitan
    sha256 "840b9cfbfc404af7fec7472c7cc4297660a94db9b73860fd3604c13d897c4ce4" => :yosemite
  end

  # we need libintl.h which is normally a part of libc6-dev
  # but within Homebrew can be found in gettext
  depends_on "gettext"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["gettext"].include}"
    ENV.append "LDFLAGS",  "-L#{Formula["gettext"].lib} -lintl"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"numdiff", "--version"
  end
end
