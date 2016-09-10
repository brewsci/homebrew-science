class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.22.tar.gz"
  sha256 "a1cdd0c7838839fa92cf8d06990c9e210cc2702681e5b61bc917fdc20e507851"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c4fc6d65cd9bc5f556d3552a5c654650ad7b342feec772452bc9a5444434b24" => :el_capitan
    sha256 "9908a3348fe573b94fe5f2e6e34613db8def949aadad3cc42cbb116f4ef2e50a" => :yosemite
    sha256 "e02dc0e11c5ff8377325e8a4212e41a01034da3ba44a5e622df3a127a6c757a8" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
