class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.1.0.tar.gz"
  sha256 "d607d96117621e5cc563002c4c161913d95db36eeb7c4e6f51afca5f6b788fcc"
  revision 2

  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "ba195bf63ac49e7d2f7f0c5b02600b12de1d073a9d7f85fc2ae08487c9283183" => :el_capitan
    sha256 "ff75908f4cd2c63f039db3ee6cec87df200f7efb03a9adaa2d66a27de5fbc1e0" => :yosemite
    sha256 "fcc41a6ed3ef8eb051118ca3b8d754c715626adb68806a1f5e1f2458da775a1f" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "cppunit"

  if OS.mac? && MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  resource "demofile" do
    url "https://raw.githubusercontent.com/G-Node/nix-demo/master/data/spike_features.h5"
    sha256 "b486202df0527545cd53968545d5fb3700567dbf10fbf7d9ca9d9a98fe2998ac"
  end

  def install
    ENV.cxx11

    # https://github.com/G-Node/nix/pull/622
    inreplace "CMakeLists.txt", "(nix CXX)", "(nix C CXX)" if !build.head?

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    resource("demofile").stage do
      system bin/"nix-tool", "dump", "spike_features.h5"
    end
  end
end
