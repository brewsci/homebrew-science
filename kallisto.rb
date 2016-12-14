class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # doi "10.1038/nbt.3519"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.43.0.tar.gz"
  sha256 "69c3ad9a58d93298bb53ecdd4b68c2c6fa65584aed108beb4cb59a4f87c32cb5"
  revision 2

  bottle do
    cellar :any
    sha256 "d54bd352a7a24ffe9f89983894c776d1a0b871bf5f0cae6b31bcccba04eda84d" => :sierra
    sha256 "50f2e20ef894545477c3ae8dcdcfdb8f51a7558dfe142672ee7457b54d71d5ff" => :el_capitan
    sha256 "0af060b80587550b63bda115262efa29d055a6b3bbceb0084dfa9a3b1384003c" => :yosemite
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
