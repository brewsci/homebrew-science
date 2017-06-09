class Opencollada < Formula
  desc "Stream based reader and writer library for COLLADA files"
  homepage "http://www.opencollada.org"
  url "https://github.com/KhronosGroup/OpenCOLLADA/archive/v1.6.52.tar.gz"
  sha256 "fab5257a18bc153a464beed8a9a31cbdb6b156fc2a66f03cbaf065636a0199d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f76cf0de8777e058cf453a9253ec86c5f669fa1363c4ded37f98e5f87620b140" => :sierra
    sha256 "04b61ed84067d63fa6ef656b4fe71a04bc904aa3db78bd82251253e0ed19e4f0" => :el_capitan
    sha256 "616b0002069e1f06b0ff7b4a89bd556c1962fce16a2b76c64af85754753c2418" => :yosemite
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
