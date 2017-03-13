class Flexbar < Formula
  desc "Flexible barcode and adapter removal"
  homepage "https://github.com/seqan/flexbar"
  url "https://github.com/seqan/flexbar/archive/v3.0.3.tar.gz"
  sha256 "f606f9af540fcaee757bb3b48f228535e4e405ae8affbf411f6a3b22cd7f6967"
  head "https://github.com/seqan/flexbar.git"
  # tag "bioinformatics"
  # doi "10.3390/biology1030895"

  depends_on "cmake" => :build
  depends_on "seqan" => :build
  depends_on "tbb"

  needs :cxx14

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "flexbar"
    pkgshare.install "test"
  end

  test do
    assert_match "reads.fq", shell_output("#{bin}/flexbar -h 2>&1", 0)
  end
end
