class BoostCompute < Formula
  desc "C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/boostorg/compute/archive/boost-1.63.0.tar.gz"
  sha256 "a483dc993316b4423f506b8b7ef51f037133e52a565c2e4b60d2e1d31addb2f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c39bd0fe571d220bc2bf9686fd47b952015d71acd3432f7fe6bd28fbb721688" => :sierra
    sha256 "3c39bd0fe571d220bc2bf9686fd47b952015d71acd3432f7fe6bd28fbb721688" => :el_capitan
    sha256 "3c39bd0fe571d220bc2bf9686fd47b952015d71acd3432f7fe6bd28fbb721688" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.cpp").write <<-EOS.undent
      #include <iostream>
      #include <boost/compute/core.hpp>
      int main()
      {
        std::cout << "hello from "
          << boost::compute::system::default_device().name() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "hello", "-I#{include}/compute", "-framework", "OpenCL", testpath/"hello.cpp"
    output = shell_output "./hello"
    assert_match /^hello from /, output
  end
end
