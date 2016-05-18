class Hlaminer < Formula
  desc "HLA predictions from next-generation shotgun (NGS) sequence read data"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer"
  # doi "10.1186/gm396"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer/releases/1.1/HLAminer.tar.gz"
  version "1.1.0"
  sha256 "2c3e4458215f06764f58e8f3d95fb8e3a47d2a19152478d047453944c8cb84c3"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "724c4478e180fc6f630cf234360801c04d0a0f7804a7001ec1eb2a39ef9bb4d6" => :el_capitan
    sha256 "cc1cbaff172fc42207a12641c04d25d2e24e958b6b33452d67baafe889e58df0" => :yosemite
    sha256 "2f8c2b6f80d300c2d9987712a55b2d1c8d8f83af01715a74f6cc81b53997c1df" => :mavericks
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
    assert_match "HLAminer.pl [v1.1]", shell_output("#{bin}/HLAminer.pl", 255)
  end
end
