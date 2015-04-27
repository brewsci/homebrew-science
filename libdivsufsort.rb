class Libdivsufsort < Formula
  homepage "https://github.com/y-256/libdivsufsort"
  head "https://github.com/y-256/libdivsufsort.git"

  url "https://github.com/y-256/libdivsufsort/archive/2.0.1.tar.gz"
  sha256 "9164cb6044dcb6e430555721e3318d5a8f38871c2da9fd9256665746a69351e0"

  depends_on "cmake" => :build

  def install
    mkdir "libdivsufsort-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # no test due to being library only
  end
end
