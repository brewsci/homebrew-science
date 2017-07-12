class Andi < Formula
  desc "Estimate evolutionary distance between similar genomes"
  homepage "https://github.com/EvolBioInf/andi"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btu815"

  url "https://github.com/EvolBioInf/andi/releases/download/v0.11/andi-0.11.tar.gz"
  sha256 "dba29ced86bb8160b6755eb69e30f6faff7b0e6588b8239faeb67437264d5451"

  bottle do
    cellar :any
    sha256 "cee3638fab897ec5799a524ce95ef5caef0e3045048504f805a228ba6eaaa5f4" => :sierra
    sha256 "dd082c541d6f7128d093869cab86c1bb28e8cad61415fe2dd432dbffcf7661b9" => :el_capitan
    sha256 "1c71120209974c2d9810a3c1e16eb260e14ad2e5a4f302b1d1ace1a73b4d4223" => :yosemite
    sha256 "aec49457eb8725aa01abcc019c014bef6f30c2a5f2d0fd2430a29120a46b7623" => :x86_64_linux
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
