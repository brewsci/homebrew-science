class Maxima < Formula
  desc "Computer algebra system"
  homepage "http://maxima.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.38.1-source/maxima-5.38.1.tar.gz"
  sha256 "0e866536ab5847ec045ba013570f80f36206ca6ce07a5d13987010bcb321c6dc"

  bottle do
    sha256 "d88c8f10575c5fe31b5d817b664931ada2a8f5f9abe2c6027328aece3b0c17e0" => :el_capitan
    sha256 "b66a746086efe814c3e9ef5603ab9773e6853865845076fde980ab9adaef729c" => :yosemite
    sha256 "56463b0c077788ebc0f2e11686cce88f68760d419840689ef8e960a50973c1c0" => :mavericks
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
