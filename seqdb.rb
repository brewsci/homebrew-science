require 'formula'

class Seqdb < Formula
  homepage 'https://bitbucket.org/mhowison/seqdb'
  url 'https://bitbucket.org/mhowison/seqdb/downloads/seqdb-0.2.0.tar.gz'
  sha1 'd0bc522dee53a0560fefefebcdad53f627bcc540'
  revision 1

  needs :openmp

  depends_on 'hdf5'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "seqdb"
  end
end
