require 'formula'

class AllpathsLg < Formula
  homepage 'http://www.broadinstitute.org/software/allpaths-lg/blog/'
  url 'ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/2013/2013-07/allpathslg-47032.tar.gz'
  sha1 'c53cfe3443d769ddd2a77b61e2c600b3cb49bb2a'

  fails_with :clang do
    cause "The only supported compiler is GCC(>=4.7)."
  end

  fails_with :gcc do
    build 5666
    cause "You must compile this with g++ 4.7 or higher."
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/RunAllPathsLG", '--version'
  end
end
