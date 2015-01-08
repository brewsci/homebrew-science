require "formula"

class Sambamba < Formula
  homepage "http://lomereiter.github.io/sambamba"
  #tag "bioinformatics"

  url "https://github.com/lomereiter/sambamba.git", :tag => "v0.5.1"
  head "https://github.com/lomereiter/sambamba.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "132ab4f787a7753feb7a5226a96cd4f76250d920" => :yosemite
    sha1 "27d76b79803be64cf1f2cddde6032587e974968d" => :mavericks
    sha1 "681b0d0909e3781110bbab048afc1b9223a84427" => :mountain_lion
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
