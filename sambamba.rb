require "formula"

class Sambamba < Formula
  homepage "http://lomereiter.github.io/sambamba"
  #tag "bioinformatics"

  url "https://github.com/lomereiter/sambamba.git", :tag => "v0.5.1"
  head "https://github.com/lomereiter/sambamba.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 1
    sha1 "a67aae9b8f8b73bebc41d3d6b066d5c481438d28" => :yosemite
    sha1 "1fd397533b90d1ba057b80d324948bed99db639e" => :mavericks
    sha1 "27ea93b01560ecbb30e6ab3c7bb1404b6d6c9405" => :mountain_lion
  end

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
