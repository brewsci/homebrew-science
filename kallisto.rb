class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # doi "10.1038/nbt.3519"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.43.0.tar.gz"
  sha256 "69c3ad9a58d93298bb53ecdd4b68c2c6fa65584aed108beb4cb59a4f87c32cb5"
  revision 3

  bottle do
    cellar :any
    sha256 "16c0ef84758ac8c992fec4994702e4affced6b34065b7895be5f91c5e994983c" => :sierra
    sha256 "00248afaaf30532aa50f17941608310d950ec84dd064d2a4678d68b6d6440555" => :el_capitan
    sha256 "c1adba93bbeff588780c8eee54fafb74703ca47360ba8efede25619f46773cc3" => :yosemite
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
