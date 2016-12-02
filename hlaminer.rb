class Hlaminer < Formula
  desc "HLA predictions from next-generation shotgun (NGS) sequence read data"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer"
  url "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer/releases/1.3.1/HLAminer_v1-3-1.tar.gz"
  version "1.3.0"
  sha256 "a009575d80484c7c1dd188f29c21419ccca3ff7feea31128d0906cfc944959fe"
  # doi "10.1186/gm396"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b92776facda404b60f368384871a3935d96228c722bf3988f833c518f5e08d5" => :sierra
    sha256 "dcc833826d7f20b4a6305447f9672afa8b15a210725a46a617209e7462740ded" => :el_capitan
    sha256 "dcc833826d7f20b4a6305447f9672afa8b15a210725a46a617209e7462740ded" => :yosemite
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
