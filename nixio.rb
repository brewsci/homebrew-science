class Nixio < Formula
  desc "C++ library for the NIX scientific data format and model"
  homepage "http://www.g-node.org/nix"
  url "https://github.com/G-Node/nix/archive/1.1.0.tar.gz"
  sha256 "d607d96117621e5cc563002c4c161913d95db36eeb7c4e6f51afca5f6b788fcc"
  revision 3

  head "https://github.com/G-Node/nix.git"

  bottle do
    cellar :any
    sha256 "fedfe2338978e3a0512a235420e121da1ccf2d31fcee3dc55f6f2c009cf324e1" => :el_capitan
    sha256 "4c2152eb4c59383098d7ac205de4a6329106d53fb3b26de428af413daa0fadfc" => :yosemite
    sha256 "27e17c6bfbcc4322109d105139ebfaf5bbf95dceb7d4f6b243fc93172044a486" => :mavericks
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
    inreplace "CMakeLists.txt", "(nix CXX)", "(nix C CXX)" unless build.head?

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
