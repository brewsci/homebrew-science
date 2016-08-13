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
    sha256 "5f802f8df0f558465dc9259bba2f4a75f906ce7e492e0032d819698097d82c7c" => :el_capitan
    sha256 "9cbd124c722624d56d5f5778851a54b1e1f7d49bf0a0407262f65c5a5c8ec25f" => :yosemite
    sha256 "e4a1b03490e40471cadc18528a4823aa4fa87ac33bc0d49ba3214447cae33121" => :mavericks
    sha256 "eff748e6d24e09ec2fb709facc24b4175b02e95b98a74a3fff4e5212aecfb0ee" => :x86_64_linux
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
