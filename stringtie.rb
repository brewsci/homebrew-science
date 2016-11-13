class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.1.tar.gz"
  sha256 "e813b31e7d434a892e79194be1296edf24824bc5cb735851255142fb643a0ae1"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "12a4d53cfdb13779c0710c980954cac156a8798f2f0e5a258382f9dc02ea1c4f" => :sierra
    sha256 "bd6612dad917983b7e7c32f9e9ae36f631ada47d802260e76640507c6dddba12" => :el_capitan
    sha256 "c4d7ee1d4bae8d851b7b5b49c22e72390ce060f61a3f195569a1202756623628" => :yosemite
    sha256 "c8e6dc6f2272ca43ae8b1637515f2bd2fd28e4d50a8c94247e015a6293a786fc" => :x86_64_linux
  end

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end
