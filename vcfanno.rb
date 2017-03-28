require "language/go"

class Vcfanno < Formula
  desc "Annotates a VCF with sorted and tabixed input BED, BAM, and VCF files"
  homepage "https://github.com/brentp/vcfanno"
  url "https://github.com/brentp/vcfanno/archive/v0.2.4.tar.gz"
  sha256 "c96c549f09971a6d0726ebc3854cda34bb8742d36e8e3ece3ac855844e7cf6d3"
  head "https://github.com/brentp/vcfanno.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b104d7ad7ce260939f5bca4ec93dcc0365fe17a76e90531c45fe75d5f7a09dc" => :sierra
    sha256 "0067e172e03faf22651cc052e4b6d498b3df5d5926bc21c2f99493ff86c56f33" => :el_capitan
    sha256 "58e09cf98f8e2cc0dbb094f5f4e56afdbe8d6ff8cd726eea2b9ff3fc4f670a95" => :yosemite
    sha256 "8005ea465ce7549ee0ec21bb35d14e20cf599c11c4115d8c148c0ac856e68ba6" => :x86_64_linux
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "b26d9c308763d68093482582cea63d69be07a0f0"
  end

  go_resource "github.com/biogo/hts" do
    url "https://github.com/biogo/hts.git",
        :revision => "a19f56e744d183b33995e495f7697666bfa96bc4"
  end

  go_resource "github.com/brentp/bix" do
    url "https://github.com/brentp/bix.git",
        :revision => "e172ae451bd7ece7caff135e75ac6000e7b9a02c"
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
        :revision => "6c23252515492caf9b228a9d5cabcdbde29f7f82"
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
