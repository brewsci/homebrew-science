require 'formula'

class GmapGsnap < Formula
  homepage 'http://research-pub.gene.com/gmap/'
  url 'http://research-pub.gene.com/gmap/src/gmap-gsnap-2013-10-03.tar.gz'
  sha1 '0bdc3b46376e5bbe547495ee47b6483969b59144'
  version '2013-10-03'

  depends_on "samtools"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end

  def caveats; <<-EOF.undent
    You will need to either download or build indexed search databases.
    See the readme file for how to do this:
      http://research-pub.gene.com/gmap/src/README

    Databases will be installed to:
      #{share}
    EOF
  end

  def test
    system "#{bin}/gsnap", "--version"
  end
end
