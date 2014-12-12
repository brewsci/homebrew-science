require "formula"

class Sambamba < Formula
  homepage "http://lomereiter.github.io/sambamba"
  #tag "bioinformatics"

  url "https://github.com/lomereiter/sambamba.git", :tag => "v0.5.0"
  head "https://github.com/lomereiter/sambamba.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "df4e636eebe1b5d0db70ab35daf0cc106fbdc032" => :yosemite
    sha1 "2ed67cfce9731a3f732838df20181116564bb4a3" => :mavericks
    sha1 "d984e3ebb51974404e861228a55f52d22ab30526" => :mountain_lion
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
