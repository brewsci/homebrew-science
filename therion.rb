require "formula"

class Therion < Formula
  homepage "http://therion.speleo.sk"
  url "http://therion.speleo.sk/downloads/therion-5.3.15.tar.gz"
  sha1 "c518482607bb7de861d7cbb395532b2af107daa2"

  depends_on "freetype"
  depends_on "imagemagick"
  depends_on "lcdf-typetools"
  depends_on :tex
  depends_on "vtk5"
  depends_on "wxmac"

  def install
    inreplace "makeinstall.tcl" do |s|
      s.gsub! "/usr/bin", bin
      s.gsub! "/etc", etc
    end

    etc.mkpath
    bin.mkpath

    system "make config-macosx"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/therion", "--version"
  end
end
