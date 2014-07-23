require "formula"

class Atram < Formula
  homepage "https://github.com/juliema/aTRAM"
  #doi "10.5281/zenodo.10431"
  head "https://github.com/juliema/aTRAM.git"

  url "https://github.com/juliema/aTRAM/archive/v1.03.tar.gz"
  sha1 "1fec78c16ab79450a78d3bfe89d826767e721235"

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
