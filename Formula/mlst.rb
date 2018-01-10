class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  # tag "bioinformatics"

  url "https://github.com/tseemann/mlst/archive/2.8.tar.gz"
  sha256 "9cfa42fbc858113853f35e1612ff6374ba7cdb601eb21f72152624a1f5a7e7eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "17f7c1db160eb35474095cdab63b3b4ec5469824b35445119f6b8a125f11b89f" => :sierra
    sha256 "17f7c1db160eb35474095cdab63b3b4ec5469824b35445119f6b8a125f11b89f" => :el_capitan
    sha256 "17f7c1db160eb35474095cdab63b3b4ec5469824b35445119f6b8a125f11b89f" => :yosemite
  end

  depends_on "blast"
  depends_on "Moo" => :perl
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl
  depends_on "List::MoreUtils" => :perl

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlst --version")
    assert_match "senterica", shell_output("#{bin}/mlst --list 2>&1")
  end
end
