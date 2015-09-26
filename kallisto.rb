class Kallisto < Formula
  desc "kallisto: quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"

  url "https://github.com/pachterlab/kallisto/archive/v0.42.2.1.tar.gz"
  sha256 "f6f915fbfec2f8a45b2301cff528ed89051a2f0b8d2d41b87a65662f9e11a1fb"
  revision 1

  bottle do
    cellar :any
    sha256 "12a581ae91c95e08cf7bde9e8a3e3399f699c32f94e48c7158c5b50bd61ad30d" => :el_capitan
    sha256 "31e0ebb98f46daa1ebf15062b92787142cb63bf17074fb112757899976ded268" => :yosemite
    sha256 "7962d1f7355b80ccfb9dd38b0f01926c6eddd8eca9858dcb1e53f216c132556f" => :mavericks
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
