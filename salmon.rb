class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  # tag "bioinformatics"

  url "https://github.com/COMBINE-lab/salmon/archive/v0.6.0.tar.gz"
  sha256 "2a015c0f95b745fbed575d8610aea7e09cb1af55ca2c68e10ab15826fba263b1"
  revision 2

  head "https://github.com/COMBINE-lab/salmon.git"

  patch do
    url "https://github.com/COMBINE-lab/salmon/pull/70.patch"
    sha256 "7129eac8591ad954cca30576519071b1f5ea2a36206f973a1aef0bc1eb5d20da"
  end

  bottle do
    cellar :any
    sha256 "6a8708ac010f4ac175e072c2c2edba9e6d3782c6969c8907f83a203bc169df91" => :el_capitan
    sha256 "63d44f6a21369e46824218fc646cf81908cc2dfd43c927764627e8989a54d283" => :yosemite
    sha256 "7d561849727c0fceb45ee95c2d611d10ccf3c0d422d0a7202fd41b3002078666" => :mavericks
    sha256 "57c41d341e783340482e9e538bcc36c645a3ba44cde6e7b3760077f053bfcfe3" => :x86_64_linux
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
