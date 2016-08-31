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
    sha256 "0e87c2f66d747c56e71995435f0972cdd4f55042596237a677eb03c488659797" => :el_capitan
    sha256 "511676f1065cbee4099049ad351098f55111190a53b8dba63ca5182528d09a88" => :yosemite
    sha256 "3ed9cf0b24aa1e585a5b22f90f425844979c481d9f036607f3c819f13a9bf8c8" => :mavericks
    sha256 "6473702f23976c531ff21fa9720aa6e9f2d4887d5abe999bd089dee709ba2b46" => :x86_64_linux
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
