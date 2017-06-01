class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.51.tar.gz"
  sha256 "27341c629637a1b6e024c405109582d476bcc7037128aa9b29a0713c5ee67e59"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f2f06346f30d95139af3f9546f813698fac6b922324846e419539519cea5cdb" => :sierra
    sha256 "25ea02b100ff6611e588e3eac7cf8f23904039d4ee528d540de03d37bdad136a" => :el_capitan
    sha256 "f3385a45e0df9f3dd4dd27b94b50c38cac3570db429ef94c57b060c64fb30089" => :yosemite
    sha256 "65f72ce8a227582548fd2a4dcacbd9f06ce70d3d4ef585fde4c7a4c93fdddab0" => :x86_64_linux
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
