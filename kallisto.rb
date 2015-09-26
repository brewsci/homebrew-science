class Kallisto < Formula
  desc "kallisto: quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  # tag "bioinformatics"

  url "https://github.com/pachterlab/kallisto/archive/v0.42.2.1.tar.gz"
  sha256 "f6f915fbfec2f8a45b2301cff528ed89051a2f0b8d2d41b87a65662f9e11a1fb"
  revision 1

  bottle do
    cellar :any
    sha256 "294e8dc293412295d1aa6c926baf7105310deacd00ad344ac07c21e631947ad3" => :yosemite
    sha256 "807ac792ededafdedb2d6a183da765125a70f60276ef4825e7ceabccd509b074" => :mavericks
    sha256 "52f682724d030b4ea967698e0f8cb34f28b85a763145e2afb4996018bc6b4d3d" => :mountain_lion
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
