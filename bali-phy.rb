class BaliPhy < Formula
  desc "Simultaneous Bayesian estimation of alignment and phylogeny"
  homepage "http://www.bali-phy.org/"
  url "http://www.bali-phy.org/bali-phy-2.3.7.tar.gz"
  sha256 "3120f9b448d308889093aa26a5941866c2841078e5eb9f1af1e2a6cbb134356a"

  head "https://github.com/bredelings/BAli-Phy.git"

  bottle do
    sha256 "f7c749a68d0a025187e919ecdd27501553040fb9a55c0a7fa512f0cb381b2619" => :yosemite
    sha256 "779f83c020cde81bbd698b5b1851f22673f178d82250402dbeddca28d817d631" => :mavericks
    sha256 "a3273e59ff3e2b71d0e5bf67fa319bc7aeb12c2432b2ee8617e8b99c1a478437" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "boost"

  needs :cxx11

  def install
    ENV.cxx11
    mkdir "macbuild" do
      system "../configure", "--disable-debug", "--disable-dependency-tracking",
                             "--prefix=#{prefix}",
                             "--enable-cairo",
                             # "--with-system-boost",
                             # Necessary for clang 5.0, which has a default depth of 128.
                             # This is fixed in clang 5.1
                             "CXXFLAGS=-ftemplate-depth=256"
      system "make", "install"
    end
    # Move the R scripts into libexec
    libexec.mkpath
    mv Dir["#{bin}/*.R"], "#{libexec}/"
    # find_in_path was used threee times in bp-analyze.pl
    inreplace "#{bin}/bp-analyze.pl", "find_in_path(\"compare-runs.R\")", "\"#{libexec}/compare-runs.R\""
    inreplace "#{bin}/bp-analyze.pl", "find_in_path(\"compare-runs2.R\")", "\"#{libexec}/compare-runs2.R\""
    inreplace "#{bin}/bp-analyze.pl", "find_in_path(\"tree-plot1.R\")", "\"#{libexec}/tree-plot1.R\""
  end

  test do
    system "#{bin}/bali-phy", "#{share}/bali-phy/examples/Sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze.pl", "5d-1"
  end
end
