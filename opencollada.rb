class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.57.tar.gz"
  sha256 "31a4b9555aa4d12595ebb917b44e2764f5aeb6d7fe97fb1ee7a65da62a0aa990"

  bottle do
    cellar :any_skip_relocation
    sha256 "e371f456dca5117e61006db6da5c2b5ef0fcad71e8889c1e9fd101c7bd348bd1" => :sierra
    sha256 "6c32ee60605d196da1c45742e379d98cf7763e4ee173af1cfa5545e227fa2ca6" => :el_capitan
    sha256 "61d1943adb5e7b3515772e7df3b6ddbf7323022bfe5fdf5ba12d1a39cd29e76a" => :yosemite
    sha256 "76c4443cba684e9ee25b8f60753f6a70beb00274b87bd5c36b69b75730c052fd" => :x86_64_linux
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
