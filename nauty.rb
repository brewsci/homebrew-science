class Nauty < Formula
  desc "automorphism groups of graphs and digraphs"
  homepage "http://cs.anu.edu.au/~bdm/nauty/"
  url "http://users.cecs.anu.edu.au/~bdm/nauty/nauty26r5.tar.gz"
  version "26r5"
  sha256 "5043e7d8157c36bf0e7f5ccdc43136f610108d2d755bf1a30508b4cb074302eb"
  # doi "10.1016/j.jsc.2013.09.003"
  # tag "math"

  bottle do
    cellar :any
    sha256 "d144e9debed572d69471b303ce1dc8b08ca56a127e278fb51a747a6934bd0d51" => :yosemite
    sha256 "990534538b4b736801e1fb1775216124492c184b623bdcc6803e0e25b3e8bce6" => :mavericks
    sha256 "edeee6cb888c572c95ff3e206d1f3909fcd132f486f2d0cb86575ab9f699c2eb" => :mountain_lion
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
