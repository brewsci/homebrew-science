class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.6.0.tar.gz"
  sha256 "2a015c0f95b745fbed575d8610aea7e09cb1af55ca2c68e10ab15826fba263b1"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    sha256 "bfc831441f36fa387f574c15053a01fb240bfb774b060dbe62cbc4c4292e4473" => :el_capitan
    sha256 "67ed11bf84b284d2a2edb8f0bf366d73ad6f2fc415207a29e07b5e8e4ea8f2c3" => :yosemite
    sha256 "9780035febafb6db5af9163a7dc25180ee2cf1f6005f5dc21ca8a06a004e5b58" => :mavericks
  end

  # See https://github.com/kingsfordgroup/sailfish/issues/74
  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "tbb"
  depends_on "xz"

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
