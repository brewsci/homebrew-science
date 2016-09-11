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
    sha256 "fbab1f82a936c0091cbcd4ec45ceafbd777004a2caff26eaf1127bb30d86a688" => :el_capitan
    sha256 "31cdd3101d4d458cfe9d8c5da4c49068bf63ee47e38381558ff6fc31c28fd20e" => :yosemite
    sha256 "57cad6ffc94cb6b96de2adb0abbba6eac4f582b4b28b0c81e4230eb181daa433" => :mavericks
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
