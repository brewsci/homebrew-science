class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.45.tar.gz"
  sha256 "29c04320a34bf704a3a6716c3ca233bd9b435382bd493a7c52bc4dc64e53a5ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "10944d8e35b6bb2c85f0bf4f787ba54b6cea0562881d97464f6cdb4ccad755fe" => :sierra
    sha256 "88a57c33900ebe5efa2013ee6678328ba4062049863934a325a85d5814f95320" => :el_capitan
    sha256 "00e48399d0ad67136e43aa3e18d394ade2040a4a05926101a5c1888296655f8b" => :yosemite
  end

  depends_on "cmake" => :build

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
