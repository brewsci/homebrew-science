class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "http://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire.git",
      :tag => "v3.3.2",
      :revision => "f65dd9798f8efeea4d55efe34ba62f4fc3ae7ca0"
  mirror "http://arrayfire.com/arrayfire_source/arrayfire-full-3.2.2.tar.bz2"
  sha256 "7bcc13ff29bdfb647813ee0e9830ce8387217953427abe0d9904de671e600831"
  revision 1

  bottle do
    sha256 "8711a68bb9739618efd2eadc57f42d1b7a3076f09a7a2915995ddf8f93e3ba9f" => :sierra
    sha256 "91b83c4455003497b83ef155f9b3846560f59216a8df2b7f9b117ea66513406f" => :yosemite_or_later
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
  depends_on "glfw"
  depends_on :x11

  # build forge separately so we can tell it to use the system freetype
  resource "forge" do
    url "https://github.com/arrayfire/forge/archive/af3.2.2.tar.gz"
    sha256 "c81210185e9a17e085640169f562dcc3654f9a6d9e8c8389469ce1a4a31cb514"
  end

  # glew2 has discontinued glewmx support
  resource "glew1" do
    url "https://downloads.sourceforge.net/project/glew/glew/1.13.0/glew-1.13.0.tgz"
    mirror "https://mirrors.kernel.org/debian/pool/main/g/glew/glew_1.13.0.orig.tar.gz"
    sha256 "aa25dc48ed84b0b64b8d41cdd42c8f40f149c37fa2ffa39cd97f42c78d128bc7"
  end

  def install
    ENV.cxx11

    resource("glew1").stage do
      inreplace "glew.pc.in", "Requires: @requireslib@", ""
      system "make", "GLEW_PREFIX=#{libexec}/glew1", "GLEW_DEST=#{libexec}/glew1", "all"
      system "make", "GLEW_PREFIX=#{libexec}/glew1", "GLEW_DEST=#{libexec}/glew1", "install.all"
    end

    ENV.prepend "CXXFLAGS", "-I#{libexec}/glew1/include"

    resource("forge").stage do
      system "cmake", "-DGLEW_ROOT_DIR=#{libexec}/glew1", "-DUSE_LOCAL_FREETYPE:BOOL=OFF", ".", *std_cmake_args
      system "make", "install"
    end

    mkdir "build" do
      args = std_cmake_args
      args << "-DGLEW_ROOT_DIR=#{libexec}/glew1"
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
