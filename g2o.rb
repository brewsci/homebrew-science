class G2o < Formula
  desc "General Framework for Graph Optimization"
  homepage "http://openslam.org/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/20160424_git.tar.gz"
  version "2016-04-24"
  sha256 "31abd5f4acf8407c18318b04f3ffc867c8ea7de89f18d51f9e92eb734d523b24"

  bottle do
    cellar :any
    sha256 "215196968627add9914a78f8783b284639b6616d438631bb8fa6a03fa859736a" => :el_capitan
    sha256 "d5ec14194a7d06428dad81e08f2cc60f82302447328f170cea89397c56de12c1" => :yosemite
    sha256 "86807d958811da65df96019c55f7be548d704992babdf9e706a0d88b9613c951" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended
  depends_on "qt" => :optional
  depends_on "libqglviewer" => :optional

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
