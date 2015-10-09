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
    cellar :any_skip_relocation
    revision 1
    sha256 "98e6cda7f489cb2cf0856129d6c97b7ef95f808fd97ed6c0d95ae0e27c338dbd" => :el_capitan
    sha256 "ddf15219089f9baf1499f7ad00b8bba57fb911f1a77f77bcc49d4ba378072896" => :yosemite
    sha256 "c056aab6d91cbd644d88bc2c1714149a3cd06c7c844c32dad06b1521156bc500" => :mavericks
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
