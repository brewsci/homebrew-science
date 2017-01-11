class Ntcard < Formula
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/archive/1.0.0.tar.gz"
  sha256 "22f02ff4fef0a525990202e3711ac5ce972014020d3bc32ce593a6f92d01c1cc"
  head "https://github.com/bcgsc/ntCard"
  # doi "10.1093/bioinformatics/btw832"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "2e2ed0de2a798d41993829e8cc0a128ba33a39898971f0366e0e50f39139fb82" => :sierra
    sha256 "4c6e1e6b55c0a7bd1b478c694fe17c3e46fe1fe3e396776f9123dd59651978e5" => :el_capitan
    sha256 "56987a2d89be2345a3f474208e4ddaba96d28f8a09a598076b386f8e7bf7d907" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :openmp

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ntcard", "--version"
  end
end
