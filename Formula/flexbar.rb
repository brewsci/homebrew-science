class Flexbar < Formula
  desc "Flexible barcode and adapter removal"
  homepage "https://github.com/seqan/flexbar"
  url "https://github.com/seqan/flexbar/archive/v3.0.3.tar.gz"
  sha256 "f606f9af540fcaee757bb3b48f228535e4e405ae8affbf411f6a3b22cd7f6967"
  head "https://github.com/seqan/flexbar.git"
  # tag "bioinformatics"
  # doi "10.3390/biology1030895"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "cd4855a994ec369d2a2be4037436770a18f1c0018a631b2904e77b802003fe36"
    sha256 cellar: :any, el_capitan:   "053892e4788d33c20a4f2bdf91d4083baeb87b37241fbdf5bbb4df261a31def9"
    sha256 cellar: :any, yosemite:     "baba15a73024448b052ed340f337ac7d2e4171692218a44b531085fe6e222bd3"
    sha256 cellar: :any, x86_64_linux: "6cfd83496a680e6e30d27a223a396c4ce44a871fe004ade4e0927cf3125ee651"
  end

  depends_on "cmake" => :build
  depends_on "seqan" => :build
  depends_on "tbb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "flexbar"
    pkgshare.install "test"
  end

  test do
    assert_match "reads.fq", shell_output("#{bin}/flexbar -h 2>&1")
  end
end
