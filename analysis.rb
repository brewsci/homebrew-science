class Analysis < Formula
  desc "Programs for the (pre-NGS-era) analysis of population-genetic data."
  homepage "https://github.com/molpopgen/analysis"
  url "https://github.com/molpopgen/analysis/archive/0.8.8.tar.gz"
  sha256 "f9ef9e0a90fce2c0f4fe462d6c05e22fef22df1c23b63a7c64ad7b538f6e8bb0"

  bottle do
    cellar :any
    sha256 "40055b7f5992ceb0e82ebbb416c0ef9ed4ddadc128df8230edcf012242059c6b" => :yosemite
    sha256 "67b41c0f0a5ff58e4a7e56c5656bbb6daff0819e27218e3a214245f74fff502c" => :mavericks
    sha256 "5fc72ebd81ba0027610720a264ff3aba6613e10fe2de905b74b9c46c32649c55" => :mountain_lion
  end

  depends_on "gsl"
  depends_on "libsequence"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "codon", shell_output("#{bin}/gestimator 2>&1", 1)
  end
end
