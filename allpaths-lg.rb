require 'formula'

class AllpathsLg < Formula
  homepage 'http://www.broadinstitute.org/software/allpaths-lg/blog/'
  url 'ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/allpathslg-47032.tar.gz'
  sha1 'c53cfe3443d769ddd2a77b61e2c600b3cb49bb2a'

  def install
    system './configure', '--disable-debug', '--disable-dependency-tracking',
      "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    system "#{bin}/RunAllPathsLG", '--version'
  end
end
