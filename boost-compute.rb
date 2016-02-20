class BoostCompute < Formula
  desc "A C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/kylelutz/compute/archive/v0.5.tar.gz"
  sha256 "0ddace9f15c98e7dac03729b5d4686e9c43147c87b5674447fc9dac643fb26e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cfa8e661a23c62bd0bde97d304a4a12fc6649fd4c6a4f45ad009e5ec154d4d8" => :el_capitan
    sha256 "e2f34bc2c7e2ba0d606f0ee0d79402b182111cf43c78c1d8a7b0c350f54c7d06" => :yosemite
    sha256 "24130196df4d7448ae055510624e960fa55cc28193673c00e05610f1854906c9" => :mavericks
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
