class Biobloomtools < Formula
  desc "BioBloom Tools (BBT): Bloom filter for bioinformatics"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/biobloomtools/"
  # doi "10.1093/bioinformatics/btu558"
  # tag "bioinformatics"

  url "https://github.com/bcgsc/biobloom/releases/download/2.0.13/biobloomtools-2.0.13.tar.gz"
  sha256 "7b4aeef70feb3fc31db2f4695159523272eadd8787b33c2902e2970a7d569ba3"
  revision 1

  bottle do
    cellar :any
    sha256 "a76acf4ac21825264ed327f06adc99cba9e343827626ba17007fbea4bdce7d19" => :sierra
    sha256 "6f388352ca828275001592952503a874e6cbb761a2c356e18933a5e184079b6a" => :el_capitan
    sha256 "9c01f631083ffd254cd7ebd17b8aeb05d32401898b9fd235ce302594df65ea42" => :yosemite
    sha256 "66421cc1f5ec9b5e69e5b42b620ecfd04b11fdd1bd380bf91aaa1b69cc637899" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/biobloom.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "boost" => :build
  depends_on "gcc"

  needs :openmp

  def install
    system "./autogen.sh" if build.head?
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/biobloommaker", "--version"
    system "#{bin}/biobloomcategorizer", "--version"
  end
end
