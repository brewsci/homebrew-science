class BoostCompute < Formula
  desc "A C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/kylelutz/compute/archive/v0.4.tar.gz"
  sha256 "d6986155d01a02b12351d6c9cc6c85498292209c3949b3a4628c0712ec7cf01b"

  bottle do
    cellar :any
    sha256 "ec92f5a55c38b17c928d407bc63322602613789ac4ae821fde03917c18eccf50" => :yosemite
    sha256 "711ad539e5a83f864691145e407456ba9eb9d4170a06c56ccb724655501d4b9f" => :mavericks
    sha256 "1acd47a79eb8d1e3349812e307c85b6c21437022faf307876d2fe930cef88c69" => :mountain_lion
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
