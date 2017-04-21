class BoostCompute < Formula
  desc "C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/boostorg/compute/archive/boost-1.64.0.tar.gz"
  sha256 "75c76789775c2b0a4efee642d174e687146adb03e1206839db74f858ef52b971"

  bottle do
    cellar :any_skip_relocation
    sha256 "620fc37ea74ffe28dc072082ebd01dfe0c8902c9c6af9d149bc29cac4399cf2d" => :sierra
    sha256 "9bea896916de83542216bfb6868a33359a7fa94de7b6ba2790f2784e4c7a81e2" => :el_capitan
    sha256 "9bea896916de83542216bfb6868a33359a7fa94de7b6ba2790f2784e4c7a81e2" => :yosemite
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
