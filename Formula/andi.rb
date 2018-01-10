class Andi < Formula
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu815"

  url "https://github.com/EvolBioInf/andi/releases/download/v0.11/andi-0.11.tar.gz"
  sha256 "dba29ced86bb8160b6755eb69e30f6faff7b0e6588b8239faeb67437264d5451"

  bottle do
    cellar :any
    sha256 "c425a345402fa748a7b0db68ee7e64b2d29a5ab3eb9d255efeefb0bc19a4ece3" => :sierra
    sha256 "1948482416f7f91ece5e1e67a99ae2a278340a659d7068f7985a0817b5372634" => :el_capitan
    sha256 "146f7bd5d895fced30bf03c0ea3bd7674d2fcb5ac9aff11e0b0a2bd55965f65d" => :yosemite
    sha256 "a0a7c09fc0d62dbf6959806a08b244d7fde9ed4853bc0e61c4b336fdee9774c8" => :x86_64_linux
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
