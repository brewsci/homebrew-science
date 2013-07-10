require 'formula'

class AllpathsLg < Formula
  homepage 'http://www.broadinstitute.org/software/allpaths-lg/blog/'
  url 'ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/2013-01/allpathslg-44837.tar.gz'
  sha1 'e06cd70d3a0043f8f6449366aeb14742954c32c0'

  def install
    system *%w'./configure --disable-debug --disable-dependency-tracking',
      "--prefix=#{prefix}"
    system *%w'make install'
  end

  test do
    system "#{bin}/RunAllPathsLG", '--version'
  end
end
