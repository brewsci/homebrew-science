class Therion < Formula
  desc "Processes survey data and generates maps or 3D models of caves"
  homepage "https://therion.speleo.sk"
  url "https://therion.speleo.sk/downloads/therion-5.3.16.tar.gz"
  sha256 "73cda5225725d3e8cadd6fada9e506ab94b093d4e7a9fc90eaf23f8c7be6eb85"
  revision 2

  bottle do
    sha256 "216b16038889a32efa33f2907ad8192d57be7edcac41f5f904447233c749df57" => :sierra
    sha256 "4d7569ce586aaccd35a9a4f2e0037c7dd8c8c7acb020cf3fe211a4589adc7536" => :el_capitan
    sha256 "bdff18440f953e05e71fff399c40d24b5e3ed05e1a3fc733a5471f1b6f3214eb" => :yosemite
  end

  depends_on "freetype"
  depends_on "imagemagick"
  depends_on "lcdf-typetools"
  depends_on "vtk"
  depends_on "wxmac"
  depends_on "tcl-tk" if MacOS.version >= :sierra

  def install
    inreplace "Makefile", "all: outdirs $(OUTDIR)/therion doc ",
                          "all: outdirs $(OUTDIR)/therion "

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
