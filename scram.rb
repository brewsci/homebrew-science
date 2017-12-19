class Scram < Formula
  desc "Probabilistic Risk Analysis Tool"
  homepage "https://scram-pra.org"
  # Needs to pull submodules to get the customized Tango iconset for Mac.
  url "https://github.com/rakhimov/scram.git",
    :revision => "cccecbf9286a6aee945538ca4dd9141f64714f79",
    :tag => "0.16.0"
  revision 1
  head "https://github.com/rakhimov/scram.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  needs :cxx14

  # C++14 uses GCC 5.3, which is not ABI compatible with GCC 4.8
  depends_on :macos unless OS.mac?

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "libxml2"
  depends_on "qt"
  depends_on "gperftools" => :recommended

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_SHARED_LIBS=ON" << "-DBUILD_TESTS=OFF"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/scram", "--help"
    system "#{bin}/scram", "--version"
  end
end
