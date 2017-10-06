class SdslLite < Formula
  desc "Succinct Data Structure Library 2.0"
  homepage "https://github.com/simongog/sdsl-lite"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b354a078dce1076c83f61c7d7da76a72fbc738904610ae21c9db11a27d36cf3f" => :high_sierra
    sha256 "58e56e03f7f2647d9247802bcabfaa7aa52b5434ba5466d34e3627d67331388d" => :sierra
    sha256 "1d6fc36b8293e0254b2c926a857b14d31b741af7cfab0bef0f4ff562b37abb55" => :el_capitan
    sha256 "a8d641c713f69fabf88e4762ee94521a8bb7f5b1064577e1b39589ee946f90a7" => :x86_64_linux
  end

  # doi "arXiv:1311.1249v1"
  # tag "bioinformatics"

  # use git to get submodules
  # url "https://github.com/simongog/sdsl-lite/archive/v2.1.1.tar.gz"
  # sha256 "e36591338c390184760dbdddbb653d972d9c1986c8819f462e7e73ddd28b992b"
  url "https://github.com/simongog/sdsl-lite.git",
    :revision => "0546faf0552142f06ff4b201b671a5769dd007ad",
    :tag => "v2.1.1"

  head "https://github.com/simongog/sdsl-lite.git"

  depends_on "cmake" => :build

  # this library is now part of SDSL - should remove the formula?
  conflicts_with "libdivsufsort"

  needs :cxx11

  def install
    ENV.cxx11
    system "./install.sh", prefix
    pkgshare.install "examples", "extras", "tutorial"
  end

  test do
    ENV.cxx11
    exe = "fm-index"
    system *ENV.cxx.split, "-o", exe,
      "-I#{opt_include}", pkgshare/"examples/fm-index.cpp",
      "-L#{opt_lib}", "-lsdsl", "-ldivsufsort", "-ldivsufsort64"
    assert_match "FM-index", shell_output("./#{exe} 2>&1", 1)
  end
end
