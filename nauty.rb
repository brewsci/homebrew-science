class Nauty < Formula
  homepage "http://cs.anu.edu.au/~bdm/nauty/"
  url "http://cs.anu.edu.au/~bdm/nauty/nauty25r9.tar.gz"
  version "25r9"
  sha1 "a533cfd764bf56b35e117c46cb85b0142833e8b2"

  bottle do
    cellar :any
    sha256 "d144e9debed572d69471b303ce1dc8b08ca56a127e278fb51a747a6934bd0d51" => :yosemite
    sha256 "990534538b4b736801e1fb1775216124492c184b623bdcc6803e0e25b3e8bce6" => :mavericks
    sha256 "edeee6cb888c572c95ff3e206d1f3909fcd132f486f2d0cb86575ab9f699c2eb" => :mountain_lion
  end

  deprecated_option "run-tests" => "with-checks"

  option "without-checks", "Skip building the included test programs"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "checks" if build.with? "checks"

    bin.install %w[
      NRswitchg addedgeg amtog biplabg catg complg copyg countg
      deledgeg directg dreadnaut dretog genbg geng genrang gentourng labelg
      linegraphg listg multig newedgeg pickg planarg ranlabg shortg showg subdivideg
      watercluster2
    ]

    prefix.install "nug25.pdf"
  end

  def caveats; <<-EOS.undent
    User guide was saved locally to:
      #{opt_prefix}/nug25.pdf
    EOS
  end
end
