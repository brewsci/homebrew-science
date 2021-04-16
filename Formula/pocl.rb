class Pocl < Formula
  desc "MIT-licensed open source implementation of the OpenCL standard"
  homepage "https://pocl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pocl/pocl-0.14.tar.gz"
  sha256 "2127bf925a91fbbe3daf2f1bac0da5c8aceb16e2a9434977a3057eade974106a"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 sierra:       "e840d7622cc3a4e2991cee46438f4338d3d792b880df87fd997f495c977c4fde"
    sha256 el_capitan:   "750fd4166e8cddc574d57e283eec0d7a2e8fa50831c42d6e24a5f989fbe2e9b8"
    sha256 yosemite:     "0c57dd7d46167d461626abf00d3635cdd39086bda540c84bffd85c99fad7d2de"
    sha256 x86_64_linux: "6a531d396319978d4c69ba6315832b3c23ee27aedb2b4296836c7c239d319a8f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "libtool"
  depends_on "llvm"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
