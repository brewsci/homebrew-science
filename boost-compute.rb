class BoostCompute < Formula
  desc "C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/boostorg/compute/archive/boost-1.62.0.tar.gz"
  sha256 "d66f898b23de79874812d21fb9e986835e3a30202ecee3ad6899ba451c93e44b"

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
