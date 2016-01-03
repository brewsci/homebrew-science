class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "http://arrayfire.com"

  stable do
    url "https://github.com/arrayfire/arrayfire.git",
      :tag => "v3.2.2",
      :revision => "7507b61b3f89c99d23900ce4b66d3f8aeef4e609"
    mirror "http://arrayfire.com/arrayfire_source/arrayfire-full-3.2.2.tar.bz2"
    sha256 "7bcc13ff29bdfb647813ee0e9830ce8387217953427abe0d9904de671e600831"
  end

  bottle do
    sha256 "2df7a97b0ecf66b090bc3ecca712b15312f122ccc946123aee48f2e57ed7e998" => :yosemite
    sha256 "1c410a35ce155304266d7c7326b366e6051d6e3fa68ce39900384f3b728b1ae9" => :mavericks
  end

  # https://github.com/arrayfire/arrayfire/issues/794
  depends_on :macos => :mavericks

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "boost-compute" => :build
  depends_on "pkg-config" => :build
  depends_on "freeimage"
  depends_on "fftw"
  depends_on "clblas"
  depends_on "clfft"
  needs :cxx11
  # forge dependencies - remove once forge moves to its own formula
  depends_on "fontconfig"
  depends_on "glew"
  depends_on "homebrew/versions/glfw3"
  depends_on :x11

  # build forge separately so we can tell it to use the system freetype
  resource "forge" do
    url "https://github.com/arrayfire/forge/archive/af3.2.2.tar.gz"
    sha256 "c81210185e9a17e085640169f562dcc3654f9a6d9e8c8389469ce1a4a31cb514"
  end

  def install
    ENV.cxx11
    resource("forge").stage do
      system "cmake", "-DUSE_LOCAL_FREETYPE:BOOL=OFF", ".", *std_cmake_args
      system "make", "install"
    end

    mkdir "build" do
      args = std_cmake_args
      args << "-DBUILD_TEST:BOOL=OFF"
      args << "-DBUILD_OPENCL:BOOL=ON"
      args << "-DUSE_SYSTEM_CLBLAS:BOOL=ON"
      args << "-DUSE_SYSTEM_CLFFT:BOOL=ON"
      args << "-DUSE_SYSTEM_BOOST_COMPUTE:BOOL=ON"
      args << "-DUSE_SYSTEM_FORGE:BOOL=ON"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <arrayfire.h>
      int main(int argc, char *argv[])
      {
        int device = argc > 1 ? atoi(argv[1]) : 0;
        af::setDevice(device);
        af::info();
        af::array A = af::randu(5,3, f32);
        af_print(A);
        af::array B = af::fft(A);
        af_print(B);
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test_cpu", "-I#{opt_include}", "-L#{opt_lib}", "-lafcpu", testpath/"test.cpp"
    system "./test_cpu"
  end
end
