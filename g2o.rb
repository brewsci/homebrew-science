class G2o < Formula
  desc "General Framework for Graph Optimization"
  homepage "http://openslam.org/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/20160424_git.tar.gz"
  version "2016-04-24"
  sha256 "31abd5f4acf8407c18318b04f3ffc867c8ea7de89f18d51f9e92eb734d523b24"
  revision 1

  bottle do
    sha256 "99f76190dede20cc71932e7839968f93f2d2bc013a38a7da20e2751e97f9809c" => :sierra
    sha256 "becd7cd3f246ca0b3c57d85e593e60ce25e65612d5780671ca3a96a94bc9e261" => :el_capitan
    sha256 "9a18728b140b1b8229e0c74931dad900c749b34c0351cfaf2d73cb8af38811f8" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended

  def install
    cmake_args = ["-DBUILD_CSPARSE=" + ((build.with? "suite-sparse") ? "OFF" : "ON")]
    mkdir "build" do
      system "cmake", "..", *(std_cmake_args + cmake_args)
      system "make", "install"
    end
    pkgshare.install "g2o/examples"
  end

  test do
    cp_r pkgshare/"examples/simple_optimize", testpath
    libs = %w[-lg2o_core -lg2o_csparse_extension -lg2o_solver_csparse -lg2o_stuff -lg2o_types_slam2d -lg2o_types_slam3d]
    cd "simple_optimize" do
      system ENV.cxx, "simple_optimize.cpp", "-I#{opt_include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "simple_optimize", "-L#{Formula["suite-sparse"].opt_lib}", "-lcxsparse", "-L#{opt_lib}", *libs
      system "curl", "-k", "-O", "https://svn.openslam.org/data/svn/g2o/trunk/data/2d/intel/intel.g2o"
      system "./simple_optimize", "intel.g2o"
    end
  end
end
