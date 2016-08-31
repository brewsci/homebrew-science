class Analysis < Formula
  desc "Programs for the (pre-NGS-era) analysis of population-genetic data."
  homepage "https://github.com/molpopgen/analysis"
  url "https://github.com/molpopgen/analysis/archive/0.8.8.tar.gz"
  sha256 "f9ef9e0a90fce2c0f4fe462d6c05e22fef22df1c23b63a7c64ad7b538f6e8bb0"
  revision 1
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "73715fa6c7409ed0a61a1ef1fc52d9be3ecfb6b957cff457dda00e78994f7a07" => :el_capitan
    sha256 "7401dbfefd51ca79a1108e74bcfe28ba6d07d3e7ba00dfd66be2741fe42083fa" => :yosemite
    sha256 "46f056c0fe1224a7d1f177d0baed6d1b13ee3948078570de3204833e4aac8dbc" => :mavericks
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
