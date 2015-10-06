class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://downloads.sourceforge.net/project/wxmaxima/wxMaxima/15.08.2/wxmaxima-15.08.2.tar.gz"
  sha256 "7ad3f018e42d15d06bee5af10053edb72e441c1d1feee318dc6eb927db6a26c5"

  bottle do
    cellar :any
    sha256 "a54821d1c686fcf9c703ec8d77ebeba20287a9149a27122a44ce710dbfeeeb79" => :el_capitan
    sha256 "f7874990a2beda17a4a9988faa63549be59d2cd79f671302cbce280290e68296" => :yosemite
    sha256 "1d8b3865a225a7b797b28a6d41e5a8004b1e4f6f1c70f1c2d136e1b33c5e7be5" => :mavericks
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
