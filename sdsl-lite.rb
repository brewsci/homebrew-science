class SdslLite < Formula
  desc "Succinct Data Structure Library 2.0"
  homepage "https://github.com/simongog/sdsl-lite"
  bottle do
    cellar :any_skip_relocation
    sha256 "48ae4f44f316ba307b190b87e01a119d01d81f22521e6ec2a27f60f14cc7611d" => :el_capitan
    sha256 "e6ea4f8b2e4c5f3618ab2ea6faf7a6cadc4caff92f498f8f0fa934381edd2cac" => :yosemite
    sha256 "f3ce68732cce03d5108064f8eafd3ea5fadab326c515edb3aee5c140fcf586af" => :mavericks
    sha256 "e631a05046077faba0842186fe5f313f569b233506d7d568a4de4afd0f75f710" => :x86_64_linux
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
