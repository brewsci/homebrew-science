class Kallisto < Formula
  desc "kallisto: quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"

  url "https://github.com/pachterlab/kallisto/archive/v0.42.2.tar.gz"
  sha256 "6107fed6089c4c4e8a3f8d16c2539736321c134b518c95600ae93ddd3d699219"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "c8b7c6a9684f79cff90ab95d0ab4a1f11517f983e08b2ff8eb01a8c446dce6df" => :yosemite
    sha256 "df50619cee612d023a1ec8c37b6083d4c20b03a21be3c4257610bf15a4a7f3b0" => :mavericks
    sha256 "2ddbf8882262dae72a63b99f9b21826cc1b4d21b0473ca70f885f5c505e69e28" => :mountain_lion
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
