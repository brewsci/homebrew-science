class GmapGsnap < Formula
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  # doi "10.1093/bioinformatics/btq057"
  # tag "bioinformatics"

  version "2016-05-01"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-#{version}.tar.gz"
  sha256 "ab13a849613c978a6fd584908f758db599143fe5f9e8910e4904c1dea9dfcb8e"

  bottle do
    sha256 "0686ca5e5ee73d8843f87639739441a7cc3114d25c192b480e8c2d30ee9f7f3e" => :yosemite
    sha256 "7b81377c26c58fe54ab12b9e029860aeb83d5c81f906afa496b572f4ea1b68c8" => :mavericks
    sha256 "35abe7c62b228386cf2523311c5106838b3ab8bd294317a816402347cbd07194" => :mountain_lion
  end

  depends_on "samtools"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<-EOF.undent
    You will need to either download or build indexed search databases.
    See the readme file for how to do this:
      http://research-pub.gene.com/gmap/src/README

    Databases will be installed to:
      #{share}
    EOF
  end

  test do
    system "#{bin}/gsnap", "--version"
  end
end
