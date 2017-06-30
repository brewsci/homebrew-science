class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.55.tar.gz"
  sha256 "1290df4c153eec157a382268832bf217b2edcf727aa8d70e50647e203a10640e"

  bottle do
    cellar :any_skip_relocation
    sha256 "68f453f911fef0711acd000c506ee2b9d6560792b15b4bd68c480941c4a55245" => :sierra
    sha256 "4a3606e48cf02cd0faaf37e7b2720e4ab8d245fb875d2203891ca874ac453376" => :el_capitan
    sha256 "4d435ae058803ae9055b515321c0a4c666c5cd4c39202b30957023c4212fe22f" => :yosemite
    sha256 "88b2e8567550aef5c76ede79f86f4b8316baed985585ed23904f490208e323d5" => :x86_64_linux
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
