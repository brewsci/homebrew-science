class Shogun < Formula
  desc "Large scale machine learning toolbox"
  homepage "http://www.shogun-toolbox.org"
  url "http://shogun-toolbox.org/archives/shogun/releases/4.1/sources/shogun-4.1.0.tar.bz2"
  sha256 "0eb313a95606edee046768a4577d63f32f7ccce340bed7bf0ff0d69225567185"
  revision 3

  bottle do
    sha256 "e734aecddf6c15ea499801aef74d8926cba94e11d3966d28c07279260d356da5" => :sierra
    sha256 "4efac4782795a59e7f7a0782653e9aba95e39d0b68c2fbd77ef333eadf688b29" => :el_capitan
    sha256 "f31bd97b5e5a269f79c93f314fa90317dd9f3b4ff03335eb31a059d175915e77" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "xz"
  depends_on "lzo"
  depends_on "snappy"
  depends_on "hdf5"
  depends_on "protobuf" => (MacOS.version < :mavericks) ? ["c++11"] : []
  depends_on "json-c"
  depends_on "readline"
  depends_on "nlopt"
  depends_on "eigen@3.2"
  depends_on "arpack"
  depends_on "colpack"
  depends_on "glpk"
  depends_on "r" => :optional
  depends_on "lua" => :optional
  depends_on "octave" => :optional
  depends_on "opencv" => :optional
  depends_on :java => :optional
  depends_on :python => :optional

  if build.with? "python"
    depends_on "swig" => :build
    depends_on "numpy" => :python
    depends_on "matplotlib" => :python
  end

  needs :cxx11

  def cmake_use(opt, arg)
    "-D#{arg}=#{build.with?(opt) ? "ON" : "OFF"}"
  end

  # fix error downloading gmock; remove for > 4.1.0
  # upstream commit from 26 Aug 2016 "Googlecode is dead for good"
  patch do
    url "https://github.com/shogun-toolbox/shogun/commit/4dd6193.patch"
    sha256 "f8bc03d603e7a43d38e36568fc82652290069efc4e70f5cef7a17429480ab881"
  end

  def install
    # fix build of modular interfaces with SWIG 3.0.5 on MacOSX
    # https://github.com/shogun-toolbox/shogun/pull/2694
    # https://github.com/shogun-toolbox/shogun/commit/fef8937d215db7
    ENV.append_to_cflags "-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0"

    args = std_cmake_args + [
      "-DBUILD_EXAMPLES=OFF",
      "-DBUNDLE_ARPREC=OFF",
      "-DBUNDLE_COLPACK=OFF",
      "-DBUNDLE_EIGEN=OFF",
      "-DBUNDLE_JSON=OFF",
      "-DBUNDLE_NLOPT=OFF",
      "-DENABLE_TESTING=ON",
      "-DENABLE_COVERAGE=OFF",
      "-DLIB_INSTALL_DIR=#{lib}",
      "-DCmdLineStatic=ON",
      cmake_use("opencv", "OpenCV"),
      cmake_use("r", "RModular"),
      cmake_use("octave", "OctaveModular"),
      cmake_use("lua", "LuaModular"),
      cmake_use("python", "PythonModular"),
      cmake_use("java", "JavaModular"),
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "GoogleMock"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.sg").write <<-EOF.undent
      new_classifier LIBSVM
      save_classifier test.model
      exit
    EOF
    system bin/"shogun", "test.sg"
    assert File.exist?("test.model")
  end
end
