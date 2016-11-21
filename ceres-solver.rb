class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  # Using the RC as stable for the sake of compatibility with the current eigen
  # https://github.com/ceres-solver/ceres-solver/issues/240
  url "http://ceres-solver.org/ceres-solver-1.12.0rc4.tar.gz"
  sha256 "ea8f161a110dd3a0bc563f8d13e5a04a0d34867303b309e2a07c73583e59d66d"

  bottle do
    cellar :any
    sha256 "a95deb9b7a50ba068b83f148dfa30c9521a6b2d8f0a753653c14d53a12e58601" => :sierra
    sha256 "a71f90430e1613b79644726d4ecf254926b7822fdee5054300dbcef2ad85c377" => :el_capitan
    sha256 "fcf4975781e9cd609fd332352bbd6081c858383e5f28ad8e09a70e695e70ade2" => :yosemite
  end

  head do
    url "https://ceres-solver.googlesource.com/ceres-solver.git"

    depends_on "sphinx-doc" => :build
  end

  option "without-test", "Do not build and run the tests (not recommended)."
  deprecated_option "without-tests" => "without-test"

  depends_on "cmake" => :run
  depends_on "glog"
  depends_on "gflags"
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended
  if build.with? "suite-sparse"
    depends_on "metis"
  elsif OS.linux?
    depends_on "openblas" => :recommended
  end

  def install
    so = OS.mac? ? "dylib" : "so"
    cmake_args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DEIGEN_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
    ]
    if build.with? "suite-sparse"
      cmake_args << "-DMETIS_LIBRARY=#{Formula["metis"].opt_lib}/libmetis.#{so}"
    else
      cmake_args << "-DSUITESPARSE=OFF"
    end
    cmake_args << "-DBUILD_DOCUMENTATION=ON" if build.head?
    system "cmake", ".", *cmake_args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
    pkgshare.install "examples", "data"
    doc.install "docs/html"
  end

  test do
    cp pkgshare/"examples/helloworld.cc", testpath
    (testpath/"CMakeLists.txt").write <<-EOS.undent
      cmake_minimum_required(VERSION 2.8)
      project(helloworld)
      find_package(Ceres REQUIRED)
      include_directories(${CERES_INCLUDE_DIRS})
      add_executable(helloworld helloworld.cc)
      target_link_libraries(helloworld ${CERES_LIBRARIES})
    EOS

    system "cmake", "-DCeres_DIR=#{share}/Ceres", "."
    system "make"
    assert_match "CONVERGENCE", shell_output("./helloworld", 0)
  end
end
