class Openbr < Formula
  desc "Open Source Biometric Recognition"
  homepage "http://www.openbiometrics.org/"

  bottle do
    sha256 "0e9cecc03ce39f45e26c94a6854bdd1ab922f49cc307209fc008366f67bec309" => :el_capitan
    sha256 "a4809628fb738aee27b5a4ff7d5e3cfd86a788871c89601f1126b5eefc555e0b" => :yosemite
    sha256 "ad3e698e6a00c5e0a785811dd193a52a63f08f9856b13a4a6b216f913ab216d8" => :mavericks
  end

  # Use git to get submodules
  # url "https://github.com/biometrics/openbr/archive/v1.1.0.tar.gz"
  # sha256 "42daf5dc1aa8e61ec8fc3305b0665cde952583ca674826e78e7ca48ae8f78821"
  url "https://github.com/biometrics/openbr.git",
    :revision => "e6fbbaa60f74fb29bdb432f27f1683526cb84069",
    :tag => "v1.1.0"

  head "https://github.com/biometrics/openbr.git"

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "opencv"
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
