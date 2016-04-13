class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  # tag "bioinformatics"

  url "https://github.com/tseemann/mlst/archive/2.4.tar.gz"
  sha256 "6263e124bbc5f481d94dddaf4906fef05babdd9fe6e8b30de8ffbf9bdb0dfb1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "83ec1a322611873ab1af0ed53d742fe941b84306e10e884d47243ea4e5440504" => :el_capitan
    sha256 "ce53a3b8878e2c5d5529eec4eef56ec3f4299529f98a976377f0b755533cc63b" => :yosemite
    sha256 "cecf476ef1498f75d9528daed0780f64fab2ca7f0c1ad92cb9c55742fa257b9c" => :mavericks
  end

  depends_on "blast"
  depends_on "Moo" => :perl
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl
  depends_on "List::MoreUtils" => :perl

  def install
    # if version is bumped before tag next time, this can be removed.
    inreplace "bin/mlst", "my $VERSION = \"2.3\"", "my $VERSION = \"2.4\""
    prefix.install Dir["*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mlst --version")
    assert_match "senterica", shell_output("#{bin}/mlst --list 2>&1")
  end
end
