require "language/go"

class Vcfanno < Formula
  desc "Annotates a VCF with sorted and tabixed input BED, BAM, and VCF files"
  homepage "https://github.com/brentp/vcfanno"
  url "https://github.com/brentp/vcfanno/archive/v0.1.0.tar.gz"
  sha256 "36086400e0774cbeb03db39e45ba33471bf225f6c703783799d06cd4b3809fb2"
  head "https://github.com/brentp/vcfanno.git"

  bottle do
    cellar :any
    sha256 "f347d7e77234ce7119789ccf4c9d67375edb46f67bf59123ac99d8cb6f754964" => :yosemite
    sha256 "55c7e64a989303207b4663edcaed598b4414a3c9460211ca2fc7e6eea7a4af7a" => :mavericks
    sha256 "fa722c41b7602e55cef998ecddd0a66cbf08fda2beea9e2bc07d573e5a91c929" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/biogo/hts" do
    url "https://github.com/biogo/hts.git",
        :revision => "a19f56e744d183b33995e495f7697666bfa96bc4"
  end

  go_resource "github.com/brentp/bix" do
    url "https://github.com/brentp/bix.git",
        :revision => "80f233091d396e7c7096de3251d994e84d16216a"
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
        :revision => "eed1c7917d2f4a7bbed5e9bf6a0ce64cbd2918c5"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "b4690f45fa1cafc47b1c280c2e75116efe40cc13"
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
