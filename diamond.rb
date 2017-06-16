class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.9.8.tar.gz"
  sha256 "435a56a9d4c383bf560a640c9c5da44a5200661808184b968825c5217700c511"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d98f8907ee9b3ef3b015d20c2bbf8fd2d1ae6ab07b4705d3a401314dd8c7c30" => :sierra
    sha256 "8023616726cc73e6fbeba09fa5a00a23d6190e36e19b9ba473d01c19297d1368" => :el_capitan
    sha256 "70799b45d513ba78a4d71118e947a3bfb801aa21c073a176bee4a370a87126ab" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
