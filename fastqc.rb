class Fastqc < Formula
  desc "Quality control tool for high throughput sequence data"
  homepage "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  # tag "bioinformatics"

  url "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip"
  sha256 "dd7a5ad80ceed2588cf6d6ffe35e0f161c0d9977ed08355f5e4d9473282cbd66"

  bottle do
    cellar :any_skip_relocation
    sha256 "19e697374ecfde749c3d8ee4c7a8a6cff4b080bd6c5964345922880312f3afa1" => :el_capitan
    sha256 "978abf5981b17859e6370f24dbff84e7572b7e7f6c9ec2942f1c17c742c5ad9f" => :yosemite
    sha256 "274ad6885a1c7d3bdb496c253f03bd29a1ac4341ee766e2180c4ef41db3b4210" => :mavericks
    sha256 "3d3db346d39306991f675ddf8dbeeb665bc8b59513bbc10fd9882441cce70a3f" => :x86_64_linux
  end

  depends_on :java

  def install
    chmod 0755, "fastqc"
    prefix.install Dir["*"]
    mkdir_p bin
    ln_s prefix/"fastqc", bin/"fastqc"
  end

  test do
    system "fastqc", "-h"
  end
end
