require "language/go"

class Vcfanno < Formula
  desc "Annotates a VCF with sorted and tabixed input BED, BAM, and VCF files"
  homepage "https://github.com/brentp/vcfanno"
  url "https://github.com/brentp/vcfanno/archive/v0.2.8.tar.gz"
  sha256 "cdb550f28d9b6d15105432b0414afa735a352839e27eda4efa954f29c000e7f8"
  head "https://github.com/brentp/vcfanno.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "565ed1833d34af1854f4a666d7c67216e090b8e933c51fd06519e3c9a171cd8a" => :sierra
    sha256 "57f9990c7e35194f0cc10fbffd50d5b85c687ad755bd81098b12fff202ddc696" => :el_capitan
    sha256 "dcc5aebf6c72a6f568660ba3acc1aef25a36c5630191275875fe66dee7e83b01" => :yosemite
    sha256 "f48bb1f0bd6b7f5467cf9bddbdf4bf3fc11d547c902f73462d523c8634dd97d9" => :x86_64_linux
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "a368813c5e648fee92e5f6c30e3944ff9d5e8895"
  end

  go_resource "github.com/biogo/hts" do
    url "https://github.com/biogo/hts.git",
        :revision => "8bf89f2e2bfa34e19ccb510d0b5ce3f5e8413ba6"
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
        :revision => "17ed276c3d6d1fd24dbbc4b8d467a207d35663f1"
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
        :revision => "d7c94f1a80ede93a621ed100866e6d4745ca8c22"
  end

  go_resource "github.com/yuin/gopher-lua" do
    url "https://github.com/yuin/gopher-lua.git",
        :revision => "2243d714d6c94951d8ccca8c851836ff47d401c9"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "054b33e6527139ad5b1ec2f6232c3b175bd9a30c"
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
