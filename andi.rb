class Andi < Formula
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu815"

  url "https://github.com/EvolBioInf/andi/releases/download/v0.9.2/andi-0.9.2.tar.gz"
  sha256 "3bb5a114995c50d800d9d7c4cd984f259b18f785a6627f81eceee47481a4f1d3"

  bottle do
    cellar :any
    sha256 "caa3c95977c845f8e3635d342a6c07b43e1e26505b68ab1d817aed7b7f664f31" => :yosemite
    sha256 "b1cedba1d1807db3811f25e06f6942e51aa86a1d11c8645892a9a43bd86d4203" => :mavericks
    sha256 "75953fc9b966ef6fc4efab3c2c47fa30d096a91617788f9431a58d6d97b35f13" => :mountain_lion
  end

  depends_on "libdivsufsort"

  def install
    lib = Formula["libdivsufsort"]
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "CPPFLAGS=-I#{lib.opt_include}",
      "LDFLAGS=-L#{lib.opt_lib}"
    system "make", "install"
  end

  test do
    system "#{bin}/andi", "--version"
  end
end
