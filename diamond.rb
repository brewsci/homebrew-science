class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.29.tar.gz"
  sha256 "7f50453153cee83bc38dc1a8983d8e4d6bc455515542161d5c62de11fc91d0d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "370d5afc9c1d7e628a43bb550702691efd5cdeeaf86b9857ca025781b6f274d2" => :sierra
    sha256 "c25cd455f899a63d8e3edb37add5644b91873dea65283aef54438750d5b69c7a" => :el_capitan
    sha256 "69e1676daba61d9a480f16db22e377a38e6a859dc4b051d28fb7930f743cbc8a" => :yosemite
    sha256 "94ee34f7d94e3fdb06fd2ee1988bd01888cce1038b20447a409708083e88d25f" => :x86_64_linux
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
