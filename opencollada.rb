class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.44.tar.gz"
  sha256 "24c9ac2ae4adb11c8b12a63d6731a3255be3a7d46f121eaa672c9087312ce6d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f2215f4660a10569ef82434a74cab25acb9b2d69cd07d12046455ad01aec3d0" => :sierra
    sha256 "2e25fb5385e49cc22e06bafe77e0f52cfa548e36f525c4da3a53f1841b4ef0bf" => :el_capitan
    sha256 "db7f3e295124e70acbffc775f86714ca5c66a17355c0cba4e0139a74686f1ac9" => :yosemite
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
