class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # doi "10.1038/nbt.3519"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.43.1.tar.gz"
  sha256 "7baef1b3b67bcf81dc7c604db2ef30f5520b48d532bf28ec26331cb60ce69400"
  revision 1

  bottle do
    cellar :any
    sha256 "af637131457128276885626f9288d2f426d6dba8ca04304dcc7a92992b87f70a" => :sierra
    sha256 "f69aae21759935900949dbb45889080535334791b0c914f3413536d8004b7eff" => :el_capitan
    sha256 "32a842d994bb5788733b2847daa4077d40860259adce3e984b07781f0e7fa400" => :yosemite
    sha256 "c7a0324786508674e4b0c3f1b623482cf27cffa647ef461a71a0874d60786092" => :x86_64_linux
  end

  needs :cxx11
  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kallisto", 1)
  end
end
