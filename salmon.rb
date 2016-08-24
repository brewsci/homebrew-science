class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.7.1.tar.gz"
  sha256 "2ff6689a1d675366342881836fa47c12eac998c6a382aa55a3be99a09cd885dc"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    cellar :any
    sha256 "56a898e692600bedf77529b9c54d48b0c103ba3b7a616c271113c028e16cf083" => :el_capitan
    sha256 "4db164ef187c888cfd99caaefb82e0cf5e6fd42f8911adfbd0932b19f86df616" => :yosemite
    sha256 "44f0fb9350fc6b3ee4c447c395cd6bed9bac78d6990bcc7e53a2b38972c56037" => :mavericks
    sha256 "30fc091b845cd0c8e6107c6ded079eec76619a2d221f8e316ef895a07b4402b4" => :x86_64_linux
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
