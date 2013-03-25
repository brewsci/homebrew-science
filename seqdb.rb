require 'formula'

class Seqdb < Formula
  homepage 'https://bitbucket.org/mhowison/seqdb'
  url 'https://bitbucket.org/mhowison/seqdb/downloads/seqdb-0.2.0.tar.gz'
  sha1 'd0bc522dee53a0560fefefebcdad53f627bcc540'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      clang does not support OpenMP, and configure can't find OpenMP
    EOS
  end

  depends_on 'hdf5'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "seqdb"
  end
end
