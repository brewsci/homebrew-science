class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.53.tar.gz"
  sha256 "edc082684565500a2473fa884aa4119977ab94a5405e97b89a65520d7d9f7b24"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bb9ba9658634211cc3a56857555011b1d3a5fbebcb0451bbedfaa80879c4c11" => :sierra
    sha256 "86cdbbaf07d7bb70cadd153128dd556b042b903996f8196bb38c9cb63d2a967c" => :el_capitan
    sha256 "a3080ef19ba08f67c4190e5e78463ef84918aadec4ec0b916b077f5bf24f02b1" => :yosemite
    sha256 "f041c10b2688f83003390a2ef5269bfcfa667233ab61006a0a84d5ebce6f2603" => :x86_64_linux
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
