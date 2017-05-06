require "language/go"

class Vcfanno < Formula
  desc "Annotates a VCF with sorted and tabixed input BED, BAM, and VCF files"
  homepage "https://github.com/brentp/vcfanno"
  url "https://github.com/brentp/vcfanno/archive/v0.2.6.tar.gz"
  sha256 "c7340f2d776ab5de2ad05b80c88014036788a373d4826c84d2483e81a20631ac"
  head "https://github.com/brentp/vcfanno.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa5ded57343904f4c10eefa751037dfc46ab69b4bcdf1cac9e6caca67366296b" => :sierra
    sha256 "329c6b0ff43598a4d9ea2c9391332babdf4cd0c2b086b6c7a72e0284987c1784" => :el_capitan
    sha256 "687e5b901ac029a3d2557e0191ef9264f5e7d33b8afb26ee3e088c149a0b4c5b" => :yosemite
    sha256 "7255adc819e59e6cade2b3bb110f353bcc17327754dff0f978426b94d5a8b76a" => :x86_64_linux
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "b26d9c308763d68093482582cea63d69be07a0f0"
  end

  go_resource "github.com/biogo/hts" do
    url "https://github.com/biogo/hts.git",
        :revision => "8593c335ea5b4d03af84f1710cabb37aa24d5f0e"
  end

  go_resource "github.com/brentp/bix" do
    url "https://github.com/brentp/bix.git",
        :revision => "630987373507c5d03349e90da1fba4789e495f03"
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
        :revision => "3160d9c2041417583f253eea20749b4d43def57f"
  end

  go_resource "github.com/brentp/xopen" do
    url "https://github.com/brentp/xopen.git",
        :revision => "83f195adad83cdc80142215b0d73b557b49b585c"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "c605e284fe17294bda444b34710735b29d1a9d90"
  end

  go_resource "github.com/yuin/gluare" do
    url "https://github.com/yuin/gluare.git",
        :revision => "8e2742cd1bf2b904720ac66eca3c2091b2ea0720"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "b402f3114ec730d8bddb074a6c137309f561aa78"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "feeb485667d1fdabe727840fe00adc22431bc86e"
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
