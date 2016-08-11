class BoostCompute < Formula
  desc "C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/kylelutz/compute/archive/v0.5.tar.gz"
  sha256 "0ddace9f15c98e7dac03729b5d4686e9c43147c87b5674447fc9dac643fb26e4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d516939ec6717a489317194b1e18bc9d9669a1a6139c6fff0997fd0880606a85" => :el_capitan
    sha256 "a74b092683200efe5479785e816e693e443f8b4c4a1319b9872b90529e0e823d" => :yosemite
    sha256 "7da9866ac9fac5fe928999d7e324db2c54d6070f6298cb7102332b7e9a718e77" => :mavericks
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
