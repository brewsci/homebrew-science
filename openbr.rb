class Openbr < Formula
  homepage "http://www.openbiometrics.org/"
  url "https://github.com/biometrics/openbr/releases/download/v0.4.1/openbr0.4.1_withModels.tar.gz"
  version "0.4.1"
  sha256 "130433a17625b81b83cefef839dc968d204fc44d2854d9c285999cd0b6c86fdc"

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "opencv"
  depends_on "eigen"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/br", "-version"
  end
end
