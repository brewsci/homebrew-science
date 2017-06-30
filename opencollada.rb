class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.55.tar.gz"
  sha256 "1290df4c153eec157a382268832bf217b2edcf727aa8d70e50647e203a10640e"

  bottle do
    cellar :any_skip_relocation
    sha256 "87bab39a924f6b713b4fe112ca648cb93b3fc35d03b66937808fb2e12beadb32" => :sierra
    sha256 "28ee2f691892b00442673bf40d21ada9f0f55655c989ea8a86f090f6cb71965f" => :el_capitan
    sha256 "73b29c0f7d79943bb2776464644ce738273e2aa99929a424eff72b44a8eea4cd" => :yosemite
    sha256 "9d7c3f1a305160d5945eb636138c5564cf15a4e4a50f01e3d3fbfdd49d69e6ce" => :x86_64_linux
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
