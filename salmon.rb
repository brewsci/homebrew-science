class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.6.0.tar.gz"
  sha256 "2a015c0f95b745fbed575d8610aea7e09cb1af55ca2c68e10ab15826fba263b1"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    sha256 "d8e67d2d7c1347c48008c1c34ce0155bd4abb693e90c5e4c7f88110dde882754" => :el_capitan
    sha256 "71e0bbea9e3293cbc1906f32d1346e45da05b08628262fd1fc7ffe5584c7b347" => :yosemite
    sha256 "6064db33c7bf432fe9f982fa84e03dff155dc3b93e4c592d968898fd8912cce0" => :mavericks
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

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/salmon", "--version"
  end
end
