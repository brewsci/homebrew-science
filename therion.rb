class Therion < Formula
  desc "Processes survey data and generates maps or 3D models of caves"
  homepage "http://therion.speleo.sk"
  url "http://therion.speleo.sk/downloads/therion-5.3.16.tar.gz"
  sha256 "73cda5225725d3e8cadd6fada9e506ab94b093d4e7a9fc90eaf23f8c7be6eb85"

  depends_on "freetype"
  depends_on "imagemagick"
  depends_on "lcdf-typetools"
  depends_on :tex
  depends_on "vtk"
  depends_on "wxmac"
  depends_on "homebrew/dupes/tcl-tk" if MacOS.version >= :sierra

  def install
    inreplace "makeinstall.tcl" do |s|
      s.gsub! "/usr/bin", bin
      s.gsub! "/etc", etc
    end

    etc.mkpath
    bin.mkpath

    system "make", "config-macosx"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/therion", "--version"
  end
end
