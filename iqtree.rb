class Iqtree < Formula
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # doi "10.1093/molbev/mst024", "10.1093/molbev/msu300", "10.1093/sysbio/syw037"
  # tag "bioinformatics"

  url "https://github.com/Cibiv/IQ-TREE/archive/v1.5.4.tar.gz"
  sha256 "f26be486180291404b056a950b62fcb29a8344d3acd4204bef543c18d1229612"

  bottle do
    cellar :any
    sha256 "6fa110388cf28b533e629779e6515f370e82a409317dd72160ab99aabad9c9c9" => :sierra
    sha256 "d7e478b051b1fa15adbaabdbee3ba86a2dabd4c231ee2252b3d2e53978db66ba" => :el_capitan
    sha256 "4dfef3abfbb77ca19827cdecaf01d23feb599504df965112afa5c1fc72ffe86b" => :yosemite
    sha256 "6ada9566c85c6f9c1768be6cb1c99654f93f2bd1c51785dd4ad8a9e987f6f6ec" => :x86_64_linux
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
