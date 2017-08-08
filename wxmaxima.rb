class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://github.com/andrejv/wxmaxima/archive/Version-17.05.1.tar.gz"
  sha256 "72394f266a784e433e232e600e7178fdd6362fd33f8ac11703db10c780676037"
  revision 1
  head "https://github.com/andrejv/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "5ce4ee1a3b4e22ea2a125b36b05a5fe0906be6587b03110b20fbe1b74afac504" => :sierra
    sha256 "dd0bf3545800e8c63bf24dba46269f54793ae01c04720c1a891fa4dab9943e26" => :el_capitan
    sha256 "c14fc77382413a5b9ade593b3d985dd80ac8c7efa61e5eedeedbc717404ee252" => :yosemite
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
