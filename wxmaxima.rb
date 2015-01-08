class Wxmaxima < Formula
  homepage "http://andrejv.github.io/wxmaxima"
  url "https://downloads.sourceforge.net/project/wxmaxima/wxMaxima/13.04.2/wxMaxima-13.04.2.tar.gz"
  sha1 "9508d3badb6c339f34e73e01c5065f679329a17c"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "d110a3c63e434f87f4441952a28d48889cfc6a10" => :yosemite
    sha1 "3e66edeec9ae6008f34024238857423fbfd04df5" => :mavericks
    sha1 "29ff6b7afe5e143eb5a2714d0565a3327f82aff2" => :mountain_lion
  end

  depends_on "wxmac"

  head do
    url "https://github.com/andrejv/wxmaxima.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    cd "locales" do
      system "make", "allmo"
    end
    system "make", "wxMaxima.app"
    prefix.install "wxMaxima.app"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end
end
