class Fastqc < Formula
  homepage "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
  # tag "bioinformatics"

  url "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.3.zip"
  sha256 "ed2e8e6793bcedbd749d65a38dd8419be841e4653319e5fdd1e0e2b063b60ffb"

  bottle do
    sha256 "2a26ea4c25aa06444d2c311ebe03fcf3246b34a681e4b2183125993cc0854125" => :yosemite
    sha256 "f291937b9522f7bc6451edbf744567fdf4ec7bd97f010fc8fbc413e01e7ab566" => :mavericks
    sha256 "2599dd06f32828921f8607b9f46afcc25ca9f7dc16d72e858216fc24940cf952" => :mountain_lion
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
