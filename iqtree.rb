class Iqtree < Formula
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # doi "10.1093/molbev/mst024", "10.1093/molbev/msu300", "10.1093/sysbio/syw037"
  # tag "bioinformatics"

  url "https://github.com/Cibiv/IQ-TREE/archive/v1.5.4.tar.gz"
  sha256 "f26be486180291404b056a950b62fcb29a8344d3acd4204bef543c18d1229612"

  bottle do
    cellar :any
    sha256 "12b58df62c8739f9d8e1d344b212d3950b33747b0cc2b790a8f01ac8f087ba7e" => :sierra
    sha256 "d26c7c16dd99407f6e2f5f9b5e6f218b6a4cc02baf14d585c08cf2e20e815d16" => :el_capitan
    sha256 "9624ac5393fac9a4aa3c6eb398cf5ef9aa73c27b9142dcec3bd4e4b68eeab44d" => :yosemite
    sha256 "4aeacfec24bc050d41ae6c4455fb2d497ad62633657e045cec61da0ffea59e36" => :x86_64_linux
  end

  needs :openmp

  depends_on "cmake" => :build
  depends_on "eigen"

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
    bin.install "build/iqtree-omp" => "iqtree"
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree 2>&1")
  end
end
