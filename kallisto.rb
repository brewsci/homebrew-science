class Kallisto < Formula
  desc "kallisto: quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.42.4.tar.gz"
  sha256 "a3939faabdd6efa172d848d04d8eddaadf452416f7d4f75b0c54e9399b92d08a"
  revision 1

  bottle do
    cellar :any
    sha256 "2756687f7e7f2d4c1e9059363bc0d5e0f61dd5249183f670555c30f50a194d5c" => :el_capitan
    sha256 "fbbbd36266770d0ea5c4cf1cafa06d49dd1cfeee6faa7c408464c33a6e92c09b" => :yosemite
    sha256 "140fd8652f40dd565312d04472e283e0d8b2c7af4dd81d005224d0b7397f9885" => :mavericks
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
