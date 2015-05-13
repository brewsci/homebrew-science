class Kallisto < Formula
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"
  url "https://github.com/pachterlab/kallisto/archive/v0.42.1.tar.gz"
  sha256 "e620623fe36ee183cf7e1245aba8e0b7490f530c2b68c81d6e8f0c21e2c97381"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "0820e4244eb899074edf27d706f9fcfec742b5e8025deef7408ec244a10e2312" => :yosemite
    sha256 "b8d02c19f47e73e56fcc976e957bcc22d008dae7f603652e329298d68c409074" => :mavericks
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
