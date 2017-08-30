class BaliPhy < Formula
  desc "Simultaneous Bayesian estimation of alignment and phylogeny"
  homepage "http://www.bali-phy.org/"
  url "http://www.bali-phy.org/files/bali-phy-2.3.8.tar.gz"
  sha256 "2e19fe736042574107300b12309b40f537364b7e9f637141863914b8680b7456"
  head "https://github.com/bredelings/BAli-Phy.git"

  bottle do
    sha256 "50fa703af91bb78303464e6e02db8603e8722e01a1275c8cc6b44254b9dacfab" => :sierra
    sha256 "62fa80287c762052da28393ff946765c1390c1da0c917cdbac6e98f0600856e9" => :el_capitan
    sha256 "9a243403ab53dc740dbfb5f34eb829fd4aa777bed544ece0d09c040994ad0b14" => :yosemite
    sha256 "86b5806848c469aaae1df3417ccfcba46468f251765235bb33036678a7176d15" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "boost"

  needs :cxx14

  def install
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
