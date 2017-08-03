class CeresSolver < Formula
  desc "C++ library for large-scale optimization"
  homepage "http://ceres-solver.org/"
  url "http://ceres-solver.org/ceres-solver-1.13.0.tar.gz"
  sha256 "1df490a197634d3aab0a65687decd362912869c85a61090ff66f073c967a7dcd"

  bottle do
    cellar :any
    sha256 "0aa9146bdc38c5e3aa1166f20144931d4e558066ea182f31f0f083fff866400d" => :sierra
    sha256 "1269b9173deb501268a642f0d0b92d157578ad05de12490bea0c90cba1a589d9" => :el_capitan
    sha256 "07c25a44340907da333474a3e53c32ddc3bab82cc835e73e0d624c4d38b02fe8" => :yosemite
  end

  head do
    url "https://ceres-solver.googlesource.com/ceres-solver.git"

    depends_on "sphinx-doc" => :build
  end

  option "without-test", "Do not build and run the tests (not recommended)."
  deprecated_option "without-tests" => "without-test"

  unless OS.mac?
    fails_with :gcc => "5" do
      cause "Dependency glog is compiled with the GCC 4.8 ABI."
    end
  end

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
