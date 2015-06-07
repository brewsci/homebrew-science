class Andi < Formula
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu815"

  url "https://github.com/EvolBioInf/andi/releases/download/v0.9.2/andi-0.9.2.tar.gz"
  sha256 "3bb5a114995c50d800d9d7c4cd984f259b18f785a6627f81eceee47481a4f1d3"

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
