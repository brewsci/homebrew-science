require "language/go"

class Vcfanno < Formula
  desc "Annotates a VCF with sorted and tabixed input BED, BAM, and VCF files"
  homepage "https://github.com/brentp/vcfanno"
  url "https://github.com/brentp/vcfanno/archive/v0.2.3.tar.gz"
  sha256 "3c47c76a8a7e6c7dbe253e68e04e65617fd8f4c57ddf8669cbf23aac497f4bf0"
  head "https://github.com/brentp/vcfanno.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10c7408b0f053a2563ac7410233d06b699fb47fbab1a686a4ae3cd8bbceb86d3" => :sierra
    sha256 "67f20cb6c9dd5f19934017584cc935764e402d79cd30848df31be061ee5ee0a4" => :el_capitan
    sha256 "a71d3d66d4a5e41262f0eb7a1ad637d1c4c4ae3b8057faddd27c646568ba3a1c" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "e643e9ef00b049d75de26e61109c5ea01885cd21"
  end

  go_resource "github.com/biogo/hts" do
    url "https://github.com/biogo/hts.git",
        :revision => "a19f56e744d183b33995e495f7697666bfa96bc4"
  end

  go_resource "github.com/brentp/bix" do
    url "https://github.com/brentp/bix.git",
        :revision => "e129d0a707dc833ba36d1b875336914a3025fc50"
  end

  go_resource "github.com/brentp/goluaez" do
    url "https://github.com/brentp/goluaez.git",
        :revision => "dd35d08e32e72e29b900868e058312e63d44c208"
  end

  go_resource "github.com/brentp/irelate" do
    url "https://github.com/brentp/irelate.git",
        :revision => "51840b4b6bb33bb4c9e413e76c402a9fb2d90bd7"
  end

  go_resource "github.com/brentp/vcfgo" do
    url "https://github.com/brentp/vcfgo.git",
        :revision => "62b853e9b91e9545641c002a1fce3ab95c6f8f72"
  end

  go_resource "github.com/brentp/xopen" do
    url "https://github.com/brentp/xopen.git",
        :revision => "688f4ede9a8e4275e6de15040dc234a6bfe75d2b"
  end

  go_resource "github.com/yuin/gluare" do
    url "https://github.com/yuin/gluare.git",
        :revision => "8e2742cd1bf2b904720ac66eca3c2091b2ea0720"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "65fb8eeb2aa6d29a7b654d61afd1a07ce3897cc9"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "a6577fac2d73be281a500b310739095313165611"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/brentp").mkpath
    ln_s buildpath, "src/github.com/brentp/vcfanno"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "vcfanno"
    bin.install "vcfanno"
    prefix.install "example"
  end

  test do
    cp_r prefix/"example", testpath
    output = shell_output("#{bin}/vcfanno -lua example/custom.lua example/conf.toml example/query.vcf.gz 2>&1")
    assert_match "annotated 337 variants", output
  end
end
