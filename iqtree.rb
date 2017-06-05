class Iqtree < Formula
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # doi "10.1093/molbev/mst024", "10.1093/molbev/msu300", "10.1093/sysbio/syw037"
  # tag "bioinformatics"

  url "https://github.com/Cibiv/IQ-TREE/archive/v1.5.5.tar.gz"
  sha256 "1be05b8ca97b43815309352b78030540e8d5f44e4003552c406538415cd6fe19"

  bottle do
    sha256 "53712f1783ffb24605f50d14d06608b2a1e7f51eaea4fbbf4945073232dfb236" => :sierra
    sha256 "da298a90b5ffac75e9d7e58c5ec8c64b9cc66df6a365d930d71005af16371b90" => :el_capitan
    sha256 "207d94cb93ba46f03dccf4cfb264279afe074b7793d364910b6aca9595846d9e" => :yosemite
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
    bin.install "build/iqtree-omp" => "iqtree"
  end

  test do
    assert_match "boot", shell_output("#{bin}/iqtree 2>&1")
  end
end
