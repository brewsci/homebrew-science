class GmapGsnap < Formula
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  # doi "10.1093/bioinformatics/btq057"
  # tag "bioinformatics"

  version "2016-05-01"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-#{version}.tar.gz"
  sha256 "ab13a849613c978a6fd584908f758db599143fe5f9e8910e4904c1dea9dfcb8e"

  bottle do
    sha256 "95b512e5a55f7c1f911a82c8954a0e0e02c76f96783c04f8f0de38b808896927" => :el_capitan
    sha256 "fec1f896a363ecc185f3977f7fb75a903d7f15176c784690464d870156bb6255" => :yosemite
    sha256 "a149666b5f7b162da16dcdddf18d08603306ad65f7a3ab74402d59c49392e883" => :mavericks
    sha256 "ec9e4f302f91d53f446ee6b261425ad5d638eb67351e9a227aac47f7afdb8066" => :x86_64_linux
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
