require "formula"

class GmapGsnap < Formula
  homepage "http://research-pub.gene.com/gmap/"
  #doi "10.1093/bioinformatics/btq057"
  #tag "bioinformatics"

  version "2014-05-15"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-#{version}.tar.gz"
  sha1 "775e427e8747a3348adfc7caecf720bcd6c26f58"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "50861e3482efc2e6dbd301bc006db9ab75656e08" => :yosemite
    sha1 "37c897f1c50bc3186d468b2e4780b93490c8c1a5" => :mavericks
    sha1 "4e2c7e4d63d1873714c1d89a0c20ca2c82501e40" => :mountain_lion
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
