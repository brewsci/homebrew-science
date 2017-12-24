class Iqtree < Formula
  desc "Efficient phylogenomic software by maximum likelihood"
  homepage "http://www.iqtree.org/"
  # doi "10.1093/molbev/mst024", "10.1093/molbev/msu300", "10.1093/sysbio/syw037"
  # tag "bioinformatics"

  url "https://github.com/Cibiv/IQ-TREE/archive/v1.6.0.tar.gz"
  sha256 "283e5f251652fdc8375f0b8eb28cb1b1866f764e2286bae6fe2b53f9d39adebe"

  bottle do
    sha256 "dbe34a68aacc7e76c5312a8141916c922ac5d77fda89d029f44fa372cb8341cf" => :high_sierra
    sha256 "2cfbe86ef8a2f7da60ef237c034d69805c84b9de7b07468409fe33c9e52efddf" => :sierra
    sha256 "a1453d22e3fa9bad8b468aade7378346b94c80942f43cf1870faf612fd9f00b5" => :el_capitan
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
