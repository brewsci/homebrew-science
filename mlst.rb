class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  # tag "bioinformatics"

  url "https://github.com/tseemann/mlst/archive/2.8.tar.gz"
  sha256 "9cfa42fbc858113853f35e1612ff6374ba7cdb601eb21f72152624a1f5a7e7eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "05bba00de429533482f29877e6d01644a2c1809f8cd5a191533241aa8c50dad6" => :sierra
    sha256 "2d7313e302742957e968acda005197e73a8354153057b895e29aa4c61694e42c" => :el_capitan
    sha256 "2d7313e302742957e968acda005197e73a8354153057b895e29aa4c61694e42c" => :yosemite
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
