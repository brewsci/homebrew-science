class Maxima < Formula
  desc "Computer algebra system"
  homepage "http://maxima.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.38.1-source/maxima-5.38.1.tar.gz"
  sha256 "0e866536ab5847ec045ba013570f80f36206ca6ce07a5d13987010bcb321c6dc"

  bottle do
    sha256 "cc1146cce7a4fc5b6566471009decec74cb07233c33ffe5ff65615b2b003064d" => :sierra
    sha256 "d61ee4d879fa7d95a14fc95f54ae2d59dac759a24fca0b31013e92b72aee8a39" => :el_capitan
    sha256 "8532791366e8f8be335072f115a5e64de60849cbb12e513edcc0f6ea954c13e5" => :yosemite
  end

  depends_on "sbcl" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sbcl", "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl",
                          "--enable-sbcl-exec",
                          "--enable-gettext"
    # Per build instructions
    ENV["LANG"] = "C"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
