require 'formula'

class ClustalOmega < Formula
  homepage 'http://www.clustal.org/omega/'
  url 'http://www.clustal.org/omega/clustal-omega-1.2.0.tar.gz'
  sha1 '3416bdc81328fa955a500aaf6c3a77414c8e0c2b'

  depends_on 'argtable'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system bin/'clustalo', '--version'
  end
end
