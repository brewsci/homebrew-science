require "formula"

class Nauty < Formula
  homepage "http://cs.anu.edu.au/~bdm/nauty/"
  url "http://cs.anu.edu.au/~bdm/nauty/nauty25r9.tar.gz"
  version "25r9"
  sha1 "a533cfd764bf56b35e117c46cb85b0142833e8b2"

  deprecated_option "run-tests" => "with-checks"
  option "without-checks", "Runs the included test programs"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "checks" if build.with? "checks"

    bin.install %w{ NRswitchg addedgeg amtog biplabg catg complg copyg countg
      deledgeg directg dreadnaut dretog genbg geng genrang gentourng labelg
      linegraphg listg multig newedgeg pickg planarg ranlabg shortg showg subdivideg
      watercluster2 }

    prefix.install "nug25.pdf"
  end

  def caveats; <<-EOS.undent
    User guide was saved locally to:
      #{prefix}/nug25.pdf
    EOS
  end
end
