class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "http://andrejv.github.io/wxmaxima"
  url "https://downloads.sourceforge.net/project/wxmaxima/wxMaxima/15.08.2/wxmaxima-15.08.2.tar.gz"
  sha256 "7ad3f018e42d15d06bee5af10053edb72e441c1d1feee318dc6eb927db6a26c5"

  bottle do
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
