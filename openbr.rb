class Openbr < Formula
  desc "Open Source Biometric Recognition"
  homepage "http://www.openbiometrics.org/"
  # Use git to get submodules
  # url "https://github.com/biometrics/openbr/archive/v1.1.0.tar.gz"
  # sha256 "42daf5dc1aa8e61ec8fc3305b0665cde952583ca674826e78e7ca48ae8f78821"
  url "https://github.com/biometrics/openbr.git",
    :revision => "e6fbbaa60f74fb29bdb432f27f1683526cb84069",
    :tag => "v1.1.0"
  revision 1
  head "https://github.com/biometrics/openbr.git"

  bottle do
    sha256 "a030f1fb84882e3bcd2581473a821bf517158714b8f4be66089fbc4861ad6fad" => :sierra
    sha256 "b6c5c5bd7310f22b7efd03acb3de3d74967c00c291b1140aff89d82fe5ec47bc" => :el_capitan
    sha256 "989d7986cd6ac5d1f708ab630fa7ced01d01ed10430dd26f3e4ff9dd27510ff1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "opencv@2"
  depends_on "eigen"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/br", "-version"
  end
end
