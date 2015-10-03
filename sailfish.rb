class Sailfish < Formula
  desc "Rapid Mapping-based Isoform Quantification from RNA-Seq Reads"
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish"
  bottle do
    sha256 "fd960a7653501eb528d6c74e69ae5c5daffa6634c0260047dfae2d5b43cf5dd1" => :el_capitan
    sha256 "15e6f342bd538c26992956202c63f78a8600db94be6d81141a907b326723f4b8" => :yosemite
    sha256 "0c5578f164ef9676172f44b5ad6bcafe4523e6c9b3003678c33eeead5993a139" => :mavericks
  end

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
