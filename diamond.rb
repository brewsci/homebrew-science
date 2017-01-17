class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "http://ab.inf.uni-tuebingen.de/software/diamond/"
  # doi "10.1038/nmeth.3176"
  # tag "bioinformatics"

  url "https://github.com/bbuchfink/diamond/archive/v0.8.33.tar.gz"
  sha256 "5d7dbbbecefb2ecdb53b37ed34843ddae54d18ad91556d68da927fc5696bf81a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a85b3ce2fe8e3e959aad033dcb1f9f9b5bb0a0ba7347789065b96089823578ae" => :sierra
    sha256 "b3d874e68b7ee52acf3adf1fd2466ea3141671ef7347919a0a72c0bf4f67d797" => :el_capitan
    sha256 "fc79a1171332c37207a03be4da5014768960b3b10d6dda1968f63712f5d02b9f" => :yosemite
    sha256 "b3b12ff4572bd860f744e9cb0c1f1067cd659e2c3d5e4b2e5bd7628d26cb5c1d" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "boost"

  patch do
    url "https://github.com/bbuchfink/diamond/commit/2913aa4.patch"
    sha256 "203bb13d8bdffcb5ea58062848ea7c23a9f8c8e3c608427769b1681a9d1027d1"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "gapextend", shell_output("#{bin}/diamond help 2>&1")
  end
end
