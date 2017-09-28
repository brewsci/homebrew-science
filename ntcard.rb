class Ntcard < Formula
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/archive/1.0.1.tar.gz"
  sha256 "f3f5969f2bc49a86d045749e49049717032305f5648b26c1be23bb0f8a13854a"
  head "https://github.com/bcgsc/ntCard"
  # doi "10.1093/bioinformatics/btw832"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "2e2ed0de2a798d41993829e8cc0a128ba33a39898971f0366e0e50f39139fb82" => :sierra
    sha256 "4c6e1e6b55c0a7bd1b478c694fe17c3e46fe1fe3e396776f9123dd59651978e5" => :el_capitan
    sha256 "56987a2d89be2345a3f474208e4ddaba96d28f8a09a598076b386f8e7bf7d907" => :yosemite
    sha256 "a5f230239b82190af955086c0bb1577c1d3fed240f5f0987f9f1b0bfe74a654a" => :x86_64_linux
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
