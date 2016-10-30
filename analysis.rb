class Analysis < Formula
  desc "Programs for the (pre-NGS-era) analysis of population-genetic data."
  homepage "https://github.com/molpopgen/analysis"
  url "https://github.com/molpopgen/analysis/archive/0.8.8.tar.gz"
  sha256 "f9ef9e0a90fce2c0f4fe462d6c05e22fef22df1c23b63a7c64ad7b538f6e8bb0"
  revision 1
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "2b2535fef27da3832bab9bbaf1a37bcb94425e805a4df47a82aab951b240e28d" => :sierra
    sha256 "af40b85ef8127d3331f2ae094144c0809df5029677af0a011058f37987acd2c5" => :el_capitan
    sha256 "283af443fdf89ac7de6653eb6f984283e7898089a0bcbe38323524998fcc1368" => :yosemite
    sha256 "3d8fda086feb222987f4fd7febdfa737f6d99779fea36f1e007abfc5236cc2b4" => :mavericks
    sha256 "c8d48239a4a097b76510bf6b2ee093f6f519e4fb179d768953d3956ef05614c1" => :x86_64_linux
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
