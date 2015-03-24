class Shogun < Formula
  homepage "http://www.shogun-toolbox.org"
  url "http://shogun-toolbox.org/archives/shogun/releases/4.0/sources/shogun-4.0.0.tar.bz2"
  sha256 "ab39d3cc27fc1ddf6128f6e3fc60217e73a843b51c20f5d3ceb69e6565a43695"

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
  depends_on "eigen"
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
