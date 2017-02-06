class Therion < Formula
  desc "Processes survey data and generates maps or 3D models of caves"
  homepage "http://therion.speleo.sk"
  url "http://therion.speleo.sk/downloads/therion-5.3.16.tar.gz"
  sha256 "73cda5225725d3e8cadd6fada9e506ab94b093d4e7a9fc90eaf23f8c7be6eb85"
  revision 1

  bottle do
    sha256 "2fdfda472c2801fa18be77cd43ed67934b39c672883b8d6203fa16964459b5f4" => :sierra
    sha256 "8fca10ca748ea930a6b6df78e9fc5390df335c8b7fc56ce3b4d9ae932b010c11" => :el_capitan
    sha256 "321034c5344cc8fb7dbe34781c1bb75f8c791821c438c7aefeccb06f944e27b6" => :yosemite
  end

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
