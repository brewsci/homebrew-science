class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.7.1.tar.gz"
  sha256 "2ff6689a1d675366342881836fa47c12eac998c6a382aa55a3be99a09cd885dc"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    cellar :any
    sha256 "701fe4ff264c88522a12b90cceafc1de09149b2509934ea97adbf526bbcf2ba8" => :el_capitan
    sha256 "585ed6734572b41c62f51548a39a4064d4f69915f38a2851e7cac60425d42539" => :yosemite
    sha256 "5a514675dc1d6e76d14535b9ff48feca8534addd9bbea83b95b36113585f24cc" => :x86_64_linux
  end

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
