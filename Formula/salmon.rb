class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.8.2.tar.gz"
  sha256 "299168e873e71e9b07d63a84ae0b0c41b0876d1ad1d434b326a5be2dce7c4b91"
  revision 1
  head "https://github.com/COMBINE-lab/salmon.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  # See https://github.com/kingsfordgroup/sailfish/issues/74
  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "tbb"
  depends_on "xz"
  depends_on "zlib" unless OS.mac?

  def install
    # Fix error: Unable to find the requested Boost libraries.
    ENV.deparallelize

    # Fix wonky clang reporting itself as GCC
    if ENV.compiler == :clang && MacOS.version <= :mavericks
      inreplace "include/concurrentqueue.h",
                "typedef ::max_align_t max_align_t",
                "typedef std::max_align_t max_align_t"
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/salmon", "--version"
  end
end
