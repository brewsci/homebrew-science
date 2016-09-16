class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.7.2.tar.gz"
  sha256 "d35147663d349a6c28bcabf51e85d5a45f24273be1c4cda76173ffa15bd68d0a"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    cellar :any
    sha256 "c8acb85e67e81d6bd2bedcd408937cc92e09d7a2a4d0ff56fbf4448736d9b052" => :el_capitan
    sha256 "1ba278c961a7f5bd0d22128c28c8fc8ab6bbdebce30b5f636d10a1c180b493aa" => :yosemite
    sha256 "4341b6d73b4c99ca6dbabd4a2f708cf7d7ef1fa5af1df4b6cb1ce7a26327cd39" => :mavericks
    sha256 "8872fe59fa76b0c76db2fa31599ac25830d67136afc84235b704a696f40d360e" => :x86_64_linux
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
