class Sailfish < Formula
  desc "Rapid mapping-based RNA-Seq isoform quantification"
  homepage "http://www.cs.cmu.edu/~ckingsf/software/sailfish"
  # doi "10.1038/nbt.2862"
  # tag "bioinformatics"
  url "https://github.com/kingsfordgroup/sailfish/archive/v0.10.1.tar.gz"
  sha256 "a0d6d944382f2e07ffbfd0371132588e2f22bb846ecfc3d3435ff3d81b30d6c6"

  bottle do
    sha256 "c6df8bd3a9116d061b67a44ae26d53b10ef4d3d77e01f078821208505ca9d935" => :el_capitan
    sha256 "bf415e7662f81af38304629155376e745aaee9a96cd0fd48216f0936c5ed1fc5" => :yosemite
    sha256 "eac2cb0702725332f551a53023968d396d3325dbff246cdc7f5955b3341f31c3" => :mavericks
    sha256 "38d78199750c9d1e28ed25fea65c894f1d48841daa1534eb71b92a6ea0ba29d5" => :x86_64_linux
  end

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
