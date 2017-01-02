class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.31.tar.gz"
  sha256 "b89fec7665346d80dd3e8e0c7fb599117cd0f6c9831cf568dd08bf9b894b075a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a85b3ce2fe8e3e959aad033dcb1f9f9b5bb0a0ba7347789065b96089823578ae" => :sierra
    sha256 "b3d874e68b7ee52acf3adf1fd2466ea3141671ef7347919a0a72c0bf4f67d797" => :el_capitan
    sha256 "fc79a1171332c37207a03be4da5014768960b3b10d6dda1968f63712f5d02b9f" => :yosemite
    sha256 "b3b12ff4572bd860f744e9cb0c1f1067cd659e2c3d5e4b2e5bd7628d26cb5c1d" => :x86_64_linux
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
