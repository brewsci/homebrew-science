require 'formula'

class CdHit < Formula
  homepage 'https://code.google.com/p/cdhit/'
  url 'https://cdhit.googlecode.com/files/cd-hit-v4.6.1-2012-08-27.tgz'
  version '4.6.1'
  sha1 '744be987a963e368ad46efa59227ea313c35ef5d'

  def install
    system "make"
    bin.mkpath
    system "make", "PREFIX=#{bin}", "install"
  end
end
