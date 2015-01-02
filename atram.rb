require "formula"

class Atram < Formula
  homepage "https://github.com/juliema/aTRAM"
  #doi "10.5281/zenodo.10431"
  #tag "bioinformatics"

  head "https://github.com/juliema/aTRAM.git"

  url "https://github.com/juliema/aTRAM/archive/v1.04.tar.gz"
  sha1 "dcf0d445fe188396f1c386f9dc337e1b1b27302f"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "ba333a85574dded37da27765c5dfb90a20afde22" => :yosemite
    sha1 "57bd309e3fe468a7823f95833c201464b4602af5" => :mavericks
    sha1 "d61f21d57851c775d59724e235cacec67da77513" => :mountain_lion
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
