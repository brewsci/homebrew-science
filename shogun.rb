class Shogun < Formula
  desc "Large scale machine learning toolbox"
  homepage "http://www.shogun-toolbox.org"
  url "http://shogun-toolbox.org/archives/shogun/releases/4.1/sources/shogun-4.1.0.tar.bz2"
  sha256 "0eb313a95606edee046768a4577d63f32f7ccce340bed7bf0ff0d69225567185"
  revision 2

  bottle do
    sha256 "bb97d16ea75d013d2b28cb37810d8f751aa886dc38612a4c2daeca5b993655fc" => :sierra
    sha256 "bc30027747a6fb55159eb8735f2027ad29f973aae3f8a64002b6ed1d28b191b3" => :el_capitan
    sha256 "06fcb649132cdc07bf234c4c6e05ad9e46a525aad7219cf091a38f7050117732" => :yosemite
    sha256 "9cb6d91f22eb9343bac860031b7e3fad5d119d0435136371d78ffadc61d55ed4" => :x86_64_linux
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
  depends_on "homebrew/versions/eigen32"
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
