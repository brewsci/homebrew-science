class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://github.com/andrejv/wxmaxima/archive/Version-17.05.1.tar.gz"
  sha256 "72394f266a784e433e232e600e7178fdd6362fd33f8ac11703db10c780676037"
  revision 1
  head "https://github.com/andrejv/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "1f05d9be0bc02092be0dc9ecf78cd9ba3485ad489b50abb750c9e095946b2d82" => :sierra
    sha256 "89473cdd0e0bdd147d59d1f7abcee76aacba0de3c3726d3503fe25ce2db8c3a5" => :el_capitan
    sha256 "676f53df9eb8562a6e43f45ec7fcd984c048aba7ee807bd34ec83f6df797e4b4" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "./bootstrap"
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
