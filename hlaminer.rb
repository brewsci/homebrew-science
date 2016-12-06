class Hlaminer < Formula
  desc "HLA predictions from next-generation shotgun (NGS) sequence read data"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer"
  url "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer/releases/1.3.1/HLAminer_v1-3-1.tar.gz"
  version "1.3.1"
  sha256 "a009575d80484c7c1dd188f29c21419ccca3ff7feea31128d0906cfc944959fe"
  # doi "10.1186/gm396"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "a75b67e185e84cff4dfe548c589da677498fbf8c48bae53e444ce041d3f71121" => :sierra
    sha256 "7a81a74fdd4f2b1153cc9e714d4eaf407c8bc167300acfbafae64b16cc969c94" => :el_capitan
    sha256 "7a81a74fdd4f2b1153cc9e714d4eaf407c8bc167300acfbafae64b16cc969c94" => :yosemite
  end

  depends_on "blast"
  depends_on "tasr"

  def install
    bin.install Dir["bin/*.pl"]
    (pkgshare/"scripts").install Dir["bin/*"]
    pkgshare.install "database"
    pkgshare.install "test-demo"
    doc.install Dir["docs/*"]
  end

  test do
    assert_match "HLAminer.pl [v1.3]", shell_output("#{bin}/HLAminer.pl", 255)
  end
end
