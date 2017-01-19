class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.34.tar.gz"
  sha256 "695c33c43beab64de75f14cccec84d75477a37d02bad1ffef9eb19321e19794b"

  bottle do
    cellar :any_skip_relocation
    sha256 "41e8e65b03875624c691d76741e7ef276ef3024bce9edbbdc45491a1b52d899c" => :sierra
    sha256 "a11e124e7d8ee6961cd577473b225d611e5c75047a839b89df3d1956e34967f9" => :el_capitan
    sha256 "89943d34125d121943b02ace7e6902615077b6a5325a70ec2790aceb365db3d9" => :yosemite
    sha256 "e3a9343eaadbe3260fbff4c2024eb334af96d709fa8812af39597e5934238f3f" => :x86_64_linux
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
