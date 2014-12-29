require "formula"

class GmapGsnap < Formula
  homepage "http://research-pub.gene.com/gmap/"
  #doi "10.1093/bioinformatics/btq057"
  #tag "bioinformatics"

  version "2014-05-15"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-#{version}.tar.gz"
  sha1 "775e427e8747a3348adfc7caecf720bcd6c26f58"

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
