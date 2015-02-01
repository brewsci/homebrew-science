require "formula"

class Therion < Formula
  homepage "http://therion.speleo.sk"
  url "http://therion.speleo.sk/downloads/therion-5.3.16.tar.gz"
  sha1 "3e826417038df59ff45907ad9f530b10b572d3d5"

  depends_on "freetype"
  depends_on "imagemagick"
  depends_on "lcdf-typetools"
  depends_on :tex
  depends_on "vtk"
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
