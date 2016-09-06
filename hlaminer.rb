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
    sha256 "724c4478e180fc6f630cf234360801c04d0a0f7804a7001ec1eb2a39ef9bb4d6" => :el_capitan
    sha256 "cc1cbaff172fc42207a12641c04d25d2e24e958b6b33452d67baafe889e58df0" => :yosemite
    sha256 "2f8c2b6f80d300c2d9987712a55b2d1c8d8f83af01715a74f6cc81b53997c1df" => :mavericks
    sha256 "a14c112b3a1577bf53f5be1aed2450fcee76acd856b5bdb6813c895a4c6af4bf" => :x86_64_linux
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
