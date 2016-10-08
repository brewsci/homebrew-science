class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.23.tar.gz"
  sha256 "229e6a55bf00e88d7c9f16bd3510dd926654685e65fa7757178591b9dcc0ec76"

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
