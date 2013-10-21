require 'formula'

class GmapGsnap < Formula
  homepage 'http://research-pub.gene.com/gmap/'
  version '2013-10-15'
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-#{version}.tar.gz"
  sha1 '2f2e5c00eed50f0a53c085d425c281acdbd1bbec'

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
