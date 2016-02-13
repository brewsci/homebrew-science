class Andi < Formula
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu815"

  url "https://github.com/EvolBioInf/andi/releases/download/v0.9.6.2/andi-0.9.6.2.tar.gz"
  sha256 "7f7911d625461490743aab95f0c9d4c96ed1eb47d75b20ac355d76aae0163535"

  bottle do
    cellar :any
    sha256 "caa3c95977c845f8e3635d342a6c07b43e1e26505b68ab1d817aed7b7f664f31" => :yosemite
    sha256 "b1cedba1d1807db3811f25e06f6942e51aa86a1d11c8645892a9a43bd86d4203" => :mavericks
    sha256 "75953fc9b966ef6fc4efab3c2c47fa30d096a91617788f9431a58d6d97b35f13" => :mountain_lion
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
