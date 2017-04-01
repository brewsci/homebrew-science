class Therion < Formula
  desc "Processes survey data and generates maps or 3D models of caves"
  homepage "http://therion.speleo.sk"
  url "http://therion.speleo.sk/downloads/therion-5.3.16.tar.gz"
  sha256 "73cda5225725d3e8cadd6fada9e506ab94b093d4e7a9fc90eaf23f8c7be6eb85"
  revision 1

  bottle :disable, "homebrew/dupes/tcl-tk dependency causes CI to fail for VTK"

  option "with-tex", "Build documentation"

  depends_on "freetype"
  depends_on "imagemagick"
  depends_on "lcdf-typetools"
  depends_on :tex => :optional
  depends_on "vtk"
  depends_on "wxmac"
  depends_on "homebrew/dupes/tcl-tk" if MacOS.version >= :sierra

  def install
    if build.without? "tex"
      inreplace "Makefile", "all: outdirs $(OUTDIR)/therion doc ",
                            "all: outdirs $(OUTDIR)/therion "
    end

    inreplace "makeinstall.tcl" do |s|
      s.gsub! "/usr/bin", bin
      s.gsub! "/etc", etc
      s.gsub! "/Applications", prefix
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
