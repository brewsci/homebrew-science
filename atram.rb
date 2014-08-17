require "formula"

class Atram < Formula
  homepage "https://github.com/juliema/aTRAM"
  #doi "10.5281/zenodo.10431"
  head "https://github.com/juliema/aTRAM.git"

  url "https://github.com/juliema/aTRAM/archive/v1.04.tar.gz"
  sha1 "dcf0d445fe188396f1c386f9dc337e1b1b27302f"

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
