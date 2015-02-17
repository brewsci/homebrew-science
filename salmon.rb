class Salmon < Formula
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish/downloads.html"
  # tag "bioinformatics"

  url "https://github.com/kingsfordgroup/sailfish/archive/v0.3.0.tar.gz"
  sha1 "69f5752d79b3d8c8ba477ac8ba8d96350a68ebc4"
  head "https://github.com/kingsfordgroup/sailfish.git", :branch => "develop"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "52e52d191915334cc33f7613fdcce3e0b4d71d1f" => :yosemite
    sha1 "a04b4b5eadde9c0e93c1fc6253ea8af6f3d1cb6a" => :mavericks
  end

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
