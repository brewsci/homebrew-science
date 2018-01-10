class G2o < Formula
  desc "General Framework for Graph Optimization"
  homepage "https://openslam.org/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/20170730_git.tar.gz"
  version "2017-07-30"
  sha256 "799a7a943de423f7514c6cfdc7ed1c7393a15a73ff88aa07ad3fdd571d777d22"

  bottle do
    sha256 "5c1104b9f44890e978d249d42bc84f7ad41d36077ca316b6fb0b350dc3ddf899" => :sierra
    sha256 "48a5f69bb96f362b3e37bbebe5731a902bc52d75e14133f9435f096919e8131b" => :el_capitan
    sha256 "54bc2c08aaf6772ffd319e35897fab72ae30a4a06c6083e207f36ed1228a3235" => :yosemite
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
      system ENV.cxx, "-std=c++11", "simple_optimize.cpp", "-I#{opt_include}", "-I#{Formula["eigen"].opt_include}/eigen3", "-o", "simple_optimize", "-L#{Formula["suite-sparse"].opt_lib}", "-lcxsparse", "-L#{opt_lib}", *libs
      system "curl", "-k", "-O", "https://svn.openslam.org/data/svn/g2o/trunk/data/2d/intel/intel.g2o"
      system "./simple_optimize", "intel.g2o"
    end
  end
end
