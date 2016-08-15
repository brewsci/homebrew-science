class BaliPhy < Formula
  desc "Simultaneous Bayesian estimation of alignment and phylogeny"
  homepage "http://www.bali-phy.org/"
  url "http://www.bali-phy.org/bali-phy-2.3.7.tar.gz"
  sha256 "3120f9b448d308889093aa26a5941866c2841078e5eb9f1af1e2a6cbb134356a"
  revision 1

  head "https://github.com/bredelings/BAli-Phy.git"

  bottle do
    sha256 "45db51cef110e5f82812996be15c5965ab03e3467a66145ccfbeab27fc382ef8" => :el_capitan
    sha256 "0716809b2b3dcfb1a6597c7a5ad1be30c83ddb04f142600453382f7313f3e7b7" => :yosemite
    sha256 "65e7717165ba2f21993c6a182d38bd3f16e957e9f823ddc757b818aae5d6c7eb" => :mavericks
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
    system "#{bin}/bali-phy", "#{pkgshare}/examples/Sequences/5S-rRNA/5d.fasta", "--iter=150"
    system "#{bin}/bp-analyze.pl", "5d-1"
  end
end
