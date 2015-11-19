class Mlst < Formula
  desc "Multi-Locus Sequence Typing of microbial contigs"
  homepage "https://github.com/tseemann/mlst"
  # tag "bioinformatics"

  url "https://github.com/tseemann/mlst/archive/2.0.tar.gz"
  sha256 "21030c8ee57eeab63d06f643b3074e18f81008c05da237250035eb3c779a8448"

  bottle do
    cellar :any_skip_relocation
    sha256 "83ec1a322611873ab1af0ed53d742fe941b84306e10e884d47243ea4e5440504" => :el_capitan
    sha256 "ce53a3b8878e2c5d5529eec4eef56ec3f4299529f98a976377f0b755533cc63b" => :yosemite
    sha256 "cecf476ef1498f75d9528daed0780f64fab2ca7f0c1ad92cb9c55742fa257b9c" => :mavericks
  end

  depends_on "blast"
  depends_on "File::Temp" => :perl
  depends_on "File::Spec" => :perl
  depends_on "Data::Dumper" => :perl
  depends_on "List::MoreUtils" => :perl
  depends_on "Moo" => :perl

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "senterica", shell_output("mlst --list 2>&1", 0)
  end
end
