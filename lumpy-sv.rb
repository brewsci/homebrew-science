require "formula"

class LumpySv < Formula
  homepage "https://github.com/arq5x/lumpy-sv"
  url "https://github.com/arq5x/lumpy-sv/releases/download/0.2.8/lumpy-sv-0.2.8.tar.gz"
  sha1 "d337c6871c1ecc374ff274af04978cadbf364b54"

  depends_on "bamtools" => :recommended
  depends_on "samtools" => :recommended
  depends_on "bedtools" => :recommended
  depends_on "bwa" => :optional
  depends_on "novoalign" => :optional
  depends_on "yaha" => :optional

  def install
    ENV.deparallelize
    system "make"
    bin.install "bin/lumpy"
    (share/"lumpy-sv").install Dir["scripts/*"]
  end

  test do
    system "lumpy 2>&1 |grep -q structural"
  end
end
