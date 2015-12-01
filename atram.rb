class Atram < Formula
  homepage "https://github.com/juliema/aTRAM"
  # doi "10.5281/zenodo.10431"
  # tag "bioinformatics"

  head "https://github.com/juliema/aTRAM.git"

  url "https://github.com/juliema/aTRAM/archive/v1.04.tar.gz"
  sha256 "ee05363885d1096e628582eebda4958c6316e7668da448af7ffe1b3f67286bea"

  bottle do
    sha256 "85c61052c018447043fb8ef1782a6350fbb753661b158095a6ade0bfcfdcab47" => :yosemite
    sha256 "83f6244d599a0f89837709a154a186698a3020f78bcfd3a6980f196d647b9a23" => :mavericks
    sha256 "6179c7a1ebe71914b577ebb9088e789f65a9190c0e384097d53b5d800d198e40" => :mountain_lion
  end

  depends_on "blast"
  depends_on "mafft"
  depends_on "muscle"
  depends_on "trinity"
  depends_on "velvet"

  def install
    prefix.install Dir["*"]
    cd prefix do
      system "perl #{prefix}/configure.pl -no"
    end
  end

  test do
    system "perl #{prefix}/test/test_all.pl"
  end
end
