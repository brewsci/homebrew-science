class Andi < Formula
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu815"

  url "https://github.com/EvolBioInf/andi/releases/download/v0.10/andi-0.10.tar.gz"
  sha256 "7182d43bd13aa51d12a5d69fe4e3e4f83aab8429f5030192ae860e1a1b0e3f77"

  bottle do
    cellar :any
    sha256 "f3e2f40ee6c101b1954324464ac014187ec748dba5f510e7b51d63e51a8a20ba" => :el_capitan
    sha256 "ffcad3200bbf99352b1d9e7d8063df19ebf9f821411176406a1e2e1ce3b2d68f" => :yosemite
    sha256 "a61d5d9924386ef5d196d02a7fbd09bf579cf30446fec0cff18bdd2c176f39d6" => :mavericks
    sha256 "448cef2db6aa301c7e1e8dc7585886f7d51de56218e8c701c055bc5c26b5ad67" => :x86_64_linux
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
