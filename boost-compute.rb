class BoostCompute < Formula
  desc "C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/kylelutz/compute/archive/v0.5.tar.gz"
  sha256 "0ddace9f15c98e7dac03729b5d4686e9c43147c87b5674447fc9dac643fb26e4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "28f52e30b36fcf0c8fc5717b54a3b402ea50d5864389ff187efb4dcce586bc8b" => :el_capitan
    sha256 "41bc82c96c6255bde33cd0001a27134161537e68efe3b3c2c9870fc105c9ae17" => :yosemite
    sha256 "70cf3ee624dfbaa88676434630f969ad42e2ab30fd4aad841cc9b70bc895fa11" => :mavericks
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
