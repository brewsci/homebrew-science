class Arrayfire < Formula
  desc "a general purpose GPU library"
  homepage "http://arrayfire.com"
  url "http://arrayfire.com/arrayfire_source/arrayfire-full-3.0.0.tar.bz2"
  sha256 "32cf82d6e48b50f370f4ecde6fb30c180713bf3302cd196d120c4d152b36c9d2"

  bottle do
    sha256 "8eac279009251b387b4356f2d5afa6fcfffc757bd28ec9fddee48b10e3957c3d" => :yosemite
    sha256 "24729eca4396b8005a81115a803740a113f54fb4df25a0a77fb71edf46f1d794" => :mavericks
  end

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
    url "https://github.com/arrayfire/forge/archive/af3.0.tar.gz"
    sha256 "c5664f272b5fdf5b76c782921d9f401578bd81b0534b4dfe710f4708198393bb"
  end

  patch do
    # fix missing include
    url "https://github.com/arrayfire/arrayfire/pull/793.patch"
    sha256 "032dc323c304d6b1c196f7779ddce691d08ae53baab97106da4ea74ae08b6293"
  end

  def install
    ENV.cxx11
    resource("forge").stage do
      system "cmake", "-DUSE_SYSTEM_FREETYPE:BOOL=ON", ".", *std_cmake_args
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
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test_cpu", "-I#{include}", "-L#{lib}", "-lafcpu", testpath/"test.cpp"
    system "./test_cpu"
  end
end
