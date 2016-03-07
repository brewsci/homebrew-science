class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.5.1.tar.gz"
  sha256 "8d20f62a4e3ddf7135f89356bbcf5c78674ce085997041461e516f9ed32ffe5d"

  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    sha256 "b71a13cc8ef5a0be45c94645279b95703156cfd571485501c807aa994c9410e1" => :yosemite
    sha256 "02bf82b66b2cf967aa014203606e2292abd77e41ceaadeaff48273572152643d" => :mavericks
    sha256 "e94f189aaf588c89f9d371323f9b92b47cf54e3cccbdb8d8afabd81bdeca022b" => :mountain_lion
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
