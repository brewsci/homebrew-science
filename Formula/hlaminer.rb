class Hlaminer < Formula
  desc "HLA predictions from next-generation shotgun (NGS) sequence read data"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer"
  url "http://www.bcgsc.ca/platform/bioinfo/software/hlaminer/releases/1.3.1/HLAminer_v1-3-1.tar.gz"
  version "1.3.1"
  sha256 "91d510fe9d5c731e6756f6680738bc64fb61844758ede2a4160608945b6ef8cf"
  # doi "10.1186/gm396"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7a81914e6f4781791ec84a8a4eec2449c38bdefd8a848e658a4d5c5f3343f3b9" => :sierra
    sha256 "a5ad58d7d29a571112a9848112a8d7f59924e0c8876a04bd22ce73103f0b9581" => :el_capitan
    sha256 "433c03cb3ec3d0ab2ea78902064172e8f52e424dbbce9e492c4dd0aa28489628" => :yosemite
    sha256 "898f7402a96f849c0598de4605848abef0ec7a491a792752867694f97bdd4020" => :x86_64_linux
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
