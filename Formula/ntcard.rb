class Ntcard < Formula
  desc "Estimating k-mer coverage histogram of genomics data"
  homepage "https://github.com/bcgsc/ntCard"
  url "https://github.com/bcgsc/ntCard/archive/1.0.1.tar.gz"
  sha256 "f3f5969f2bc49a86d045749e49049717032305f5648b26c1be23bb0f8a13854a"
  head "https://github.com/bcgsc/ntCard"
  # doi "10.1093/bioinformatics/btw832"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "e6f5be712e672529f080fa8e3b61c9cede78f386e76b5c18f167c558df1ff58d" => :high_sierra
    sha256 "84406bc492afb290cc7d357cd56ca372d58990d02b73a214a368620542bda2c4" => :sierra
    sha256 "15c51babe4ef3743a3bcaa02ce02360b803de48f3ed150fb7bd81f5931777605" => :el_capitan
    sha256 "742934e0175f17dbb5b15ab2dc6aaa3e95450a2e0f831488eeef600fbe7d5866" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  needs :openmp

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ntcard", "--version"
  end
end
