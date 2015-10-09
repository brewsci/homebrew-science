class CdHit < Formula
  desc "Cluster and compare protein or nucleotide sequences"
  homepage "http://cd-hit.org"
  # doi "10.1093/bioinformatics/btl158"
  # tag "bioinformatics"

  url "https://github.com/weizhongli/cdhit/releases/download/V4.6.1/cd-hit-v4.6.1-2012-08-27.tgz"
  mirror "https://cdhit.googlecode.com/files/cd-hit-v4.6.1-2012-08-27.tgz"
  version "4.6.1"
  sha256 "5e26431892609511992542c39705a1427e2fd6a526241977c527dfc74f795932"

  head "https://github.com/weizhongli/cdhit.git"

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

  test do
    assert_match "Usage", shell_output("#{bin}/cd-hit -h", 1)
  end
end
