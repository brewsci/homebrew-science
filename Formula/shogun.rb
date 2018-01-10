class Shogun < Formula
  desc "Large scale machine learning toolbox"
  homepage "http://www.shogun-toolbox.org"
  url "http://shogun-toolbox.org/archives/shogun/releases/6.0/sources/shogun-6.0.0.tar.bz2"
  sha256 "7bb0432e1eea86105f83ba74db4a89716d256693db3f678e088f2a7ca6118e82"

  bottle do
    sha256 "06aafb46d4cd4e53ebed6f8bb32e1279b5a8b5de9aae2359261cee9de87fc2ca" => :sierra
    sha256 "e5dd5b447ef40488fb32fa36e2eb943975a6b28db8ae27859e39cb8a87a077a9" => :el_capitan
    sha256 "b3d320d345da09b55ffb98a59f4fac3b2f6c2672fcbcda693fe0e7a9ee4795a3" => :yosemite
    sha256 "dfbd03cba5e1a134a520d6c06aceaa3c5143cad638fc208150d980a44e5252cf" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "lzo"
  depends_on "zlib"
  depends_on "bzip2"
  depends_on "snappy"
  depends_on "hdf5"
  depends_on "libxml2"
  depends_on "json-c"
  depends_on "curl"
  depends_on "readline"
  depends_on "nlopt"
  depends_on "eigen"
  depends_on "arpack"
  depends_on "glpk"
  depends_on "r" => :optional
  depends_on "lua" => :optional
  depends_on "octave" => :optional
  depends_on "opencv" => :optional
  depends_on :java => :optional
  depends_on :python => :optional

  if build.with? "python"
    include Language::Python::Virtualenv

    depends_on "swig" => :build

    resource "numpy" do
      url "https://files.pythonhosted.org/packages/e0/4c/515d7c4ac424ff38cc919f7099bf293dd064ba9a600e1e3835b3edefdb18/numpy-1.11.1.tar.gz"
      sha256 "dc4082c43979cc856a2bf352a8297ea109ccb3244d783ae067eb2ee5b0d577cd"
    end

    resource "matplotlib" do
      url "https://files.pythonhosted.org/packages/15/89/240b4ebcd63bcdde9aa522fbd2e13f0af3347bea443cb8ad111e3b4c6f3a/matplotlib-1.5.2.tar.gz"
      sha256 "8875d763c9e0d0ae01fefd5ebbe2b22bde5f080037f9467126d5dbee31785913"
    end
  end

  needs :cxx11

  def cmake_use(opt, arg)
    "-D#{arg}=#{build.with?(opt) ? "ON" : "OFF"}"
  end

  def install
    ENV.cxx11
    # fix build of modular interfaces with SWIG 3.0.5 on MacOSX
    # https://github.com/shogun-toolbox/shogun/pull/2694
    # https://github.com/shogun-toolbox/shogun/commit/fef8937d215db7
    ENV.append_to_cflags "-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0"

    args = std_cmake_args + [
      "-DBUILD_EXAMPLES=OFF",
      "-DBUNDLE_JSON=OFF",
      "-DBUNDLE_NLOPT=OFF",
      "-DENABLE_TESTING=ON",
      "-DENABLE_COVERAGE=OFF",
      "-DBUILD_META_EXAMPLES=OFF",
      "-DLIB_INSTALL_DIR=#{lib}",
      cmake_use("opencv", "OpenCV"),
      cmake_use("r", "RModular"),
      cmake_use("octave", "OctaveModular"),
      cmake_use("lua", "LuaModular"),
      cmake_use("python", "PythonModular"),
      cmake_use("java", "JavaModular"),
    ]

    if build.with? "python"
      virtualenv_install_with_resources
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "GoogleMock"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS
        #include <cstdlib>
        #include <cstring>
        #include <assert.h>

        #include <shogun/base/init.h>
        #include <shogun/lib/versionstring.h>

        using namespace shogun;

        int main(int argc, char** argv)
        {
          init_shogun_with_defaults();
          assert (std::strcmp(MAINVERSION, "6.0.0") == 0);
          exit_shogun();

          return EXIT_SUCCESS;
        }
      EOS

    ENV.cxx11
    cxx_with_flags = ENV.cxx.split + ["-I#{include}", "test.cpp",
                                      "-o", "test", "-L#{lib}", "-lshogun"]
    system *cxx_with_flags
    system "./test"
  end
end
