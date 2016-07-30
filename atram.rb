class Atram < Formula
  desc "Automated target restricted assembly method"
  homepage "https://github.com/juliema/aTRAM"

  # doi "10.5281/zenodo.10431"
  # tag "bioinformatics"

  url "https://github.com/juliema/aTRAM/archive/v1.04.tar.gz"
  sha256 "ee05363885d1096e628582eebda4958c6316e7668da448af7ffe1b3f67286bea"
  revision 2
  head "https://github.com/juliema/aTRAM.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f676dc882d3ca11f24dd1f97968985db717bcdecbcb4b4cb8c10ef2894ea85e" => :el_capitan
    sha256 "d0912c55cf87b536371d178312c17a35904cff15a30f5402086ec8cf3c982c80" => :yosemite
    sha256 "ff50f781b9940d5fca761d2894cc36f11f2a8928a1ae600254e0882fb4de9505" => :mavericks
    sha256 "46244967080ec4411d85949741d5a74ca3e76ad42c4a7335fff4be1d3e378768" => :x86_64_linux
  end

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
