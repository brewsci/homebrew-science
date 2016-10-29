class Andi < Formula
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu815"

  url "https://github.com/EvolBioInf/andi/releases/download/v0.10/andi-0.10.tar.gz"
  sha256 "7182d43bd13aa51d12a5d69fe4e3e4f83aab8429f5030192ae860e1a1b0e3f77"
  revision 1

  bottle do
    cellar :any
    sha256 "d1c6a0d147a5422463933a8311ceaa6aba6e0c03b1bde520c9a0fd96621affc0" => :sierra
    sha256 "92ea0b4143d62faafd41495514d5f966d761b6dd6f30bae1a16afb094628c417" => :el_capitan
    sha256 "e220eb0b520a6aec9539596af23eccb060ce3ae69667e177b2dbf0005865181e" => :yosemite
    sha256 "232bbad5b5e892049e1e3353ec754ca4daff972862011a2848de1e57bf756ea6" => :mavericks
    sha256 "de9bd35d612595c6900206fbc18adf71b6caef7ca8e042ab4ead4326358856b1" => :x86_64_linux
  end

  depends_on "gsl"

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--without-libdivsufsort"
    system "make", "install"
  end

  test do
    system "#{bin}/andi", "--version"
  end
end
