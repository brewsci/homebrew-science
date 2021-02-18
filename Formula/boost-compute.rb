class BoostCompute < Formula
  desc "C++ GPU Computing Library for OpenCL"
  homepage "https://boostorg.github.io/compute"
  url "https://github.com/boostorg/compute/archive/boost-1.66.0.tar.gz"
  sha256 "e8845fd33ca386e5a3ddb2f17cd6bc0e104ebd55ba32b15c1ff0da781c1ea7a8"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, high_sierra: "34f4336116b599a31763d2c10aac9b24e8e4c9ca269a4ce024a680352a2a72ca"
    sha256 cellar: :any_skip_relocation, sierra:      "34f4336116b599a31763d2c10aac9b24e8e4c9ca269a4ce024a680352a2a72ca"
    sha256 cellar: :any_skip_relocation, el_capitan:  "34f4336116b599a31763d2c10aac9b24e8e4c9ca269a4ce024a680352a2a72ca"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
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
