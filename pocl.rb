class Pocl < Formula
  desc "MIT-licensed open source implementation of the OpenCL standard"
  homepage "https://pocl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pocl/pocl-0.14.tar.gz"
  sha256 "2127bf925a91fbbe3daf2f1bac0da5c8aceb16e2a9434977a3057eade974106a"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "hwloc"
  depends_on "libtool" => :run

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
