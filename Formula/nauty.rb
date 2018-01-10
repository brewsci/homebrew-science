class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "http://pallini.di.uniroma1.it/"
  url "http://users.cecs.anu.edu.au/~bdm/nauty/nauty26r5.tar.gz"
  version "26r5"
  sha256 "5043e7d8157c36bf0e7f5ccdc43136f610108d2d755bf1a30508b4cb074302eb"
  # doi "10.1016/j.jsc.2013.09.003"
  # tag "math"

  bottle do
    cellar :any_skip_relocation
    sha256 "f37f9e97552f2663377c71f7149277e6c9573fe91c07d425a65a42c40dea1c6c" => :el_capitan
    sha256 "c6f11644f03d80e12cb00298f97800da9e446ca50a3c735539d229b2e57731d0" => :yosemite
    sha256 "1f91481f5a64f6a7698af50549756ff81a3ec0691a55d14e74b120a5f234901a" => :mavericks
  end

  option "without-test", "Skip building the included test programs"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "checks" if build.with? "test"

    bin.install %w[
      NRswitchg addedgeg amtog biplabg catg complg converseg copyg countg
      cubhamg deledgeg delptg directg dreadnaut dretodot dretog genbg genbgL
      geng genquarticg genrang genspecialg gentourng gentreeg hamheuristic
      labelg linegraphg listg multig newedgeg pickg planarg ranlabg shortg
      showg subdivideg twohamg vcolg watercluster2
    ]

    doc.install "nug26.pdf"
  end

  def caveats; <<-EOS.undent
    User guide was saved locally to:
      #{doc}/nug26.pdf
    EOS
  end

  test do
    # from ./runalltests
    out1 = shell_output("#{bin}/geng -ud1D7t 11 2>&1")
    out2 = shell_output("#{bin}/genrang -r3 114 100 | #{bin}/countg --nedDr -q")

    assert_match /92779 graphs generated/, out1
    assert_match /100 graphs : n=114; e=171; mindeg=3; maxdeg=3; regular/, out2
  end
end
