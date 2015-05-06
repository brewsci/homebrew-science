class Kallisto < Formula
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/v0.42.tar.gz"
  sha256 "860285d293f86113a442ff4c0f7b039123fe22644796b8aae0e5741283dfbd49"

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
