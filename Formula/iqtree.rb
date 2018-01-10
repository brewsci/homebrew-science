class Iqtree < Formula
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # doi "10.1093/molbev/mst024", "10.1093/molbev/msu300", "10.1093/sysbio/syw037"
  # tag "bioinformatics"

  url "https://github.com/Cibiv/IQ-TREE/archive/v1.6.1.tar.gz"
  sha256 "32ed901ec0d9b908218df9ac899378668abd1a0dd34f9c46cc5fcd6ff895d02c"

  bottle do
    sha256 "5ebbc2860628d5ef6600f01a331ad208e9c6d9408e9e88bbfa5dffdfd373d4ce" => :high_sierra
    sha256 "9fb5ec543d750421ccc8d8a756df4fcf7248688cd58b27b29e1c3726b2e1ee44" => :sierra
    sha256 "7ced91d8704659c858ffc73d1acf653722432033699b1c1588c69f74feb00096" => :el_capitan
    sha256 "edf54f7d3032d45c4898b5bacb6f3dd1348de9f80595a8483c79cb55f52c2d07" => :x86_64_linux
  end

  needs :openmp

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "zlib" unless OS.mac?

  def install
    if OS.mac?
      inreplace "CMakeLists.txt",
        "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -Wl,--gc-sections",
        "${CMAKE_EXE_LINKER_FLAGS_RELEASE}"
    end

    mkdir "build" do
      system "cmake", "..", "-DIQTREE_FLAGS=omp", *std_cmake_args
      system "make"
    end
    bin.install "build/iqtree"
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree 2>&1")
  end
end
