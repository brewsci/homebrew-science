require "language/go"

class Vcfanno < Formula
  homepage "https://github.com/brentp/vcfanno"
  url "https://github.com/brentp/vcfanno/archive/v0.0.2.tar.gz"
  sha256 "a452c5b8cf0abf7ed79381f3c54913e6e6959d5cce9be3ae55456eab6cff1e42"
  head "https://github.com/brentp/vcfanno.git"

  bottle do
    cellar :any
    sha256 "f347d7e77234ce7119789ccf4c9d67375edb46f67bf59123ac99d8cb6f754964" => :yosemite
    sha256 "55c7e64a989303207b4663edcaed598b4414a3c9460211ca2fc7e6eea7a4af7a" => :mavericks
    sha256 "fa722c41b7602e55cef998ecddd0a66cbf08fda2beea9e2bc07d573e5a91c929" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git", :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end
  go_resource "github.com/brentp/irelate" do
    url "https://github.com/brentp/irelate.git", :revision => "822f6099cc4bbf29c48c43299fca58d05b6d6acc"
  end
  go_resource "github.com/brentp/vcfgo" do
    url "https://github.com/brentp/vcfgo.git", :revision => "f407080371f54e3d2b87128850673d466b27cc93"
  end
  go_resource "github.com/brentp/xopen" do
    url "https://github.com/brentp/xopen.git", :revision => "3bbd096d10ebaf72eb73bb1307283d7d60089d07"
  end
  go_resource "github.com/biogo/hts" do
    url "https://github.com/biogo/hts.git", :revision => "c037c681c52d6f905234793d5fe46b002d19f73d"
  end
  go_resource "github.com/biogo/biogo" do
    url "https://github.com/biogo/biogo.git", :revision => "d120dd7b6c5c8461d76fb5650c543daf265ad5ad"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "vcfanno"
    bin.install "vcfanno"
    prefix.install "example"
  end

  test do
    cp_r prefix/"example", testpath
    output = shell_output("#{bin}/vcfanno example/conf.toml example/query.vcf")
    assert output.include? "fitcons_mean"
  end
end
