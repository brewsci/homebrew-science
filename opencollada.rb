class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.50.tar.gz"
  sha256 "a4b3f385250c5b436813ae9126709a1921ae1a31f51b184c49b61c056d477cba"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa872ee7f0974710557473af9ff38a0a1a93588379ca4073dd9815706edf9390" => :sierra
    sha256 "b08aff59690e30743fd4be131602f8116a0e23cd5bad4bc3fc8f9e894ca6149b" => :el_capitan
    sha256 "cfd62d4b99a726d72814964d48d387a8c85606ca55e0ccfc1b4cd91ea47ae654" => :yosemite
    sha256 "604fdadd5e50eff50da500ad1c32ca71a094e58bd615177f23ad91583104fa75" => :x86_64_linux
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
