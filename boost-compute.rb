class BoostCompute < Formula
  desc "C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/boostorg/compute/archive/boost-1.65.1.tar.gz"
  sha256 "a89bfc96a93647ef6572a8a7a6eb39ce265137fe80e92e9d6f728bd0591f57ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb353ebe60db639396031591a31c2af830fd4d94ad8241588114864904a1dd32" => :sierra
    sha256 "bb353ebe60db639396031591a31c2af830fd4d94ad8241588114864904a1dd32" => :el_capitan
    sha256 "bb353ebe60db639396031591a31c2af830fd4d94ad8241588114864904a1dd32" => :yosemite
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
