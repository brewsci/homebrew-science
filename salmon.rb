class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.4.2.tar.gz"
  sha256 "702c4893a3c73a72bce68b2ff1283467f470df5c6be72c1b0fcb2470229d512b"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "52e52d191915334cc33f7613fdcce3e0b4d71d1f" => :yosemite
    sha1 "a04b4b5eadde9c0e93c1fc6253ea8af6f3d1cb6a" => :mavericks
  end

  # See https://github.com/kingsfordgroup/sailfish/issues/74
  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "tbb"

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
