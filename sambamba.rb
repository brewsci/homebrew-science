require "formula"

class Sambamba < Formula
  homepage "http://lomereiter.github.io/sambamba"
  #tag "bioinformatics"

  url "https://github.com/lomereiter/sambamba.git", :tag => "v0.5.0-alpha"
  head "https://github.com/lomereiter/sambamba.git"

  depends_on "ldc" => :build

  def install
    ENV.deparallelize
    system "make", "sambamba-ldmd2-64"
    bin.install "build/sambamba"
    (libexec/"share").install "BioD/test/data/ex1_header.bam"
  end

  test do
    cd libexec/"share" do
      system "#{bin}/sambamba  sort -t2 -n ex1_header.bam -o ex1_header.nsorted.bam -m 200K"
      assert File.exist?("ex1_header.nsorted.bam")
    end
  end
end
