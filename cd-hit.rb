require 'formula'

class CdHit < Formula
  homepage 'https://code.google.com/p/cdhit/'
  url 'https://cdhit.googlecode.com/files/cd-hit-v4.6.1-2012-08-27.tgz'
  version '4.6.1'
  sha1 '744be987a963e368ad46efa59227ea313c35ef5d'

  bottle do
    cellar :any
    sha256 "59496629caa22c63051cbf97aa80fb8d2243f0da266f016cdcdf0c7ceb31eb60" => :yosemite
    sha256 "58b812dd2cfbbc900e66eebcc56b544cdf9f0ee8857282abdf84ff8dea79622c" => :mavericks
    sha256 "632cde6c3fb7355a49f0d6950eda28577eec4f1aef88e3b69b0e1b010db43150" => :mountain_lion
  end

  def install
    args = (ENV.compiler == :clang) ? [] : ["openmp=yes"]

    system "make", *args
    bin.mkpath
    system "make", "PREFIX=#{bin}", "install"
  end
end
