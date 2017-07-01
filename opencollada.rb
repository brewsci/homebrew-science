class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.56.tar.gz"
  sha256 "479162bda40326bcb19c16dc204dcda6217295fb544a4a3297019283d3148e3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "1140c175f97bc1fc5e026817c6a3b12ecf214ca1bd9c1c517cd9a702ca1a0ef4" => :sierra
    sha256 "009162499666b88cab8252cd73a7d8b21d8bfe72386bee15d64acc7164e69ebc" => :el_capitan
    sha256 "91b799c1d548ac3fc268a2b0473783a93561ba3e6793e4c198efbe7ad9d72b33" => :yosemite
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
