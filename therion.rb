class Therion < Formula
  desc "Processes survey data and generates maps or 3D models of caves"
  homepage "https://therion.speleo.sk"
  url "https://therion.speleo.sk/downloads/therion-5.3.16.tar.gz"
  sha256 "73cda5225725d3e8cadd6fada9e506ab94b093d4e7a9fc90eaf23f8c7be6eb85"
  revision 3

  bottle do
    sha256 "0007c14f7f19f1b6397fe58c367548b18ee27519b20820d53076f1453d3b0dee" => :sierra
    sha256 "452c8adc1c96ca72e660c155ae84817b7f277567b72a9c3df29b4afa73267009" => :el_capitan
    sha256 "065654456caef31f092baddccad66f9af6c420f3175cc065f97fd6e1d18c18cd" => :yosemite
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

    system "make", OS.mac? ? "config-macosx" : "config-linux"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/therion", "--version"
  end
end
