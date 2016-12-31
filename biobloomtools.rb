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
    sha256 "ed8ee8bd6bb5248e5b22fda73cfcc938c65a30e4a99dc61b2a04427497506565" => :sierra
    sha256 "d7d05e645f14ab8ec5ea2027258be5fe2efb5396acca583c7a2616a6b8aa131f" => :el_capitan
    sha256 "27200effe2f895332b0fb0e35681652364df2999393d3fc427517fc21bd429e0" => :yosemite
    sha256 "fa9992d8cb709770d8684a2b0bc8b35cb208a3f9a2e8d128f3d078ec929fec80" => :x86_64_linux
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
