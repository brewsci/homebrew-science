class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.8.2.tar.gz"
  sha256 "299168e873e71e9b07d63a84ae0b0c41b0876d1ad1d434b326a5be2dce7c4b91"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    cellar :any
    sha256 "ab7348f3a8b68324d917ee9ccb7595347a9a1a141f9760a1f11cc2e46036f372" => :sierra
    sha256 "2ac32a183fee18068aeb4fe339391b000add4219c111a1805ce57bc1ef3254b8" => :el_capitan
    sha256 "9690f02d048dd9ade014196bfecd33003a3b9da424a0f75118d74208ecf186d9" => :yosemite
    sha256 "bb8c9bf185f9ff19c9a9b53c616c408de4819ccc58712a5bb0efb673c7514283" => :x86_64_linux
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
