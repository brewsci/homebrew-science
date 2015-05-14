class Kallisto < Formula
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.42.1.tar.gz"
  sha256 "e620623fe36ee183cf7e1245aba8e0b7490f530c2b68c81d6e8f0c21e2c97381"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "4ac31c5cbe9ea2cbf9f707571b334c815e110c39af02fbd5377990873b71ac3b" => :yosemite
    sha256 "396690ea206684d83dc21066d4bdbae74d00033d029ccad3634a9a415cbb0b9d" => :mavericks
    sha256 "4cdbabe76ca4741150919680b8d1418c0cdfe43876cd864c4b935447533223fc" => :mountain_lion
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
