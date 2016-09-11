class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # doi "10.1038/nbt.3519"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.43.0.tar.gz"
  sha256 "69c3ad9a58d93298bb53ecdd4b68c2c6fa65584aed108beb4cb59a4f87c32cb5"
  revision 1

  bottle do
    cellar :any
    sha256 "fc93dd76c238ed66f842367edcd0e3da27565b1f4e360cbe5d36ee9b8bc942b9" => :el_capitan
    sha256 "ed1a4a70e2b1510465bbc3f6ab9a3d492ab2230c68509743ba07bfff3130cf45" => :yosemite
    sha256 "ea5118efaa234ff719f74f2658ae837ac0b16cd1c305438046e87d966f491762" => :mavericks
    sha256 "280c8c39e87b65be15bfcec6a9ce8925490cf2a7340aa2cc0ca0ce4ce2aebf6d" => :x86_64_linux
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
