class Atram < Formula
  desc "Automated target restricted assembly method"
  homepage "https://github.com/juliema/aTRAM"
  # doi "10.5281/zenodo.10431"
  # tag "bioinformatics"

  url "https://github.com/juliema/aTRAM/archive/v1.04.tar.gz"
  sha256 "ee05363885d1096e628582eebda4958c6316e7668da448af7ffe1b3f67286bea"
  revision 2
  head "https://github.com/juliema/aTRAM.git"

  depends_on "blast"
  depends_on "mafft"
  depends_on "muscle"
  depends_on "trinity"
  depends_on "velvet"

  def install
    prefix.install Dir["*"]
    cd prefix
    system "perl", prefix/"configure.pl", "-no"
  end

  test do
    assert_match /No shards to be made/, shell_output("perl #{prefix}/test/test_format_sra.pl -input #{prefix}/test/test_sra.fasta")
  end
end
