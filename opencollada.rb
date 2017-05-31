class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.49.tar.gz"
  sha256 "d3fa0a3ebe7f20567727d85024514359d8b7920383ba18b5c1e658b32de5ac95"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c9268f7a71faa659012daf8fcb06a3dab3263d6273d0dc06fdbc489cd1ba649" => :sierra
    sha256 "e6e30ef83d8c4d6b9dc4d6bb5a49a225df3e1700634737b638074bc32c9b8216" => :el_capitan
    sha256 "740ab009794cef6a101da846f5361d8cd32c966d83ca5f6977b708dd6b6b676e" => :yosemite
    sha256 "cb955d69afdafebd8dd67f9ed36725020ca2d3475f4bda9a020ac575a6eaa889" => :x86_64_linux
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
