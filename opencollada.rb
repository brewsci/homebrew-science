class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.47.tar.gz"
  sha256 "cba45eb0894e4eb8351f98cf699e51174817a2fdfb95e73b5f0942833e68f46c"

  bottle do
    cellar :any_skip_relocation
    sha256 "10944d8e35b6bb2c85f0bf4f787ba54b6cea0562881d97464f6cdb4ccad755fe" => :sierra
    sha256 "88a57c33900ebe5efa2013ee6678328ba4062049863934a325a85d5814f95320" => :el_capitan
    sha256 "00e48399d0ad67136e43aa3e18d394ade2040a4a05926101a5c1888296655f8b" => :yosemite
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
