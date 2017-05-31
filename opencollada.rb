class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.50.tar.gz"
  sha256 "a4b3f385250c5b436813ae9126709a1921ae1a31f51b184c49b61c056d477cba"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f938e17a782b691047dc6eae301e7dda0187729eeca958afaa721973f25e13b" => :sierra
    sha256 "ea493111ded775fce6322b6ee19adf7b6b596a2e210d8de7051cf9996b80d5b8" => :el_capitan
    sha256 "6e3761e2bcef3ff78ade00a3d7a1b45abd8b8942f87130c185119500a3fc1da2" => :yosemite
    sha256 "afa645f378314e7185846caf961628d879cfae809d67f1b960dcb79ab78d23bc" => :x86_64_linux
  end

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "libxml2"
    depends_on "pcre"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
      prefix.install "bin"
      Dir.glob("#{bin}/*.xsd") { |p| rm p }
    end
  end

  test do
    system "#{bin}/OpenCOLLADAValidator"
  end
end
