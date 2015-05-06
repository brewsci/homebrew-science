class Kallisto < Formula
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.42.tar.gz"
  sha256 "860285d293f86113a442ff4c0f7b039123fe22644796b8aae0e5741283dfbd49"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "0820e4244eb899074edf27d706f9fcfec742b5e8025deef7408ec244a10e2312" => :yosemite
    sha256 "b8d02c19f47e73e56fcc976e957bcc22d008dae7f603652e329298d68c409074" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/kallisto", 1)
  end
end
