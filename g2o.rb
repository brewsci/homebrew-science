class G2o < Formula
  desc "General Framework for Graph Optimization"
  homepage "http://openslam.org/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/20160424_git.tar.gz"
  version "2016-04-24"
  sha256 "31abd5f4acf8407c18318b04f3ffc867c8ea7de89f18d51f9e92eb734d523b24"
  revision 2

  bottle do
    sha256 "f9ff7fa45de9e01f08f562e9e2af1acd135c22e40076fab94a383642827e0b46" => :sierra
    sha256 "368e47a06a7b29f060faa3900965501b3b280868e59760f2bb58d3e080429f18" => :el_capitan
    sha256 "9115f1664d6788cf549ff5540792deebc1870fb1e3afd6e280295d91e20c9b83" => :yosemite
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
