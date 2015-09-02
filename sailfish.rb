class Sailfish < Formula
  desc "Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish"
  # doi "10.1038/nbt.2862"
  # tag "bioinformatics"
  url "https://github.com/kingsfordgroup/sailfish/archive/v0.7.5.tar.gz"
  sha256 "74f589f6dfa8d9316a9a77bb8ad9c2962f08e3a285deedc134893f6f7b1d1b18"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "tbb"
  needs :cxx11

  def install
    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sailfish", "--version"
  end
end
