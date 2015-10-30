class Kallisto < Formula
  desc "kallisto: quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.42.4.tar.gz"
  sha256 "a3939faabdd6efa172d848d04d8eddaadf452416f7d4f75b0c54e9399b92d08a"

  bottle do
    cellar :any
    sha256 "bd05faaa85f82eb758948aadc2b1caee729d0bf432176e1a365101fa97f13457" => :el_capitan
    sha256 "138b5250710b66af60938a7ad9d4606f326a58d77cf2ccb13c71cb2bd522a600" => :yosemite
    sha256 "93424c1d76999a095151702eb50b1caf302021f471cd3d4afde7f7aa5defcec3" => :mavericks
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
