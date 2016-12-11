class OrocosKdl < Formula
  homepage "http://www.orocos.org/kdl"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.3.0.tar.gz"
  sha256 "7be2dd5e4f4c1ceac2cdf1f4fae3d94d4ffd9fc1af8d483c05f04e80ef84b3f9"
  revision 1
  head "https://github.com/orocos/orocos_kinematics_dynamics.git"

  bottle do
    sha256 "fa61429d10a90316344c29be3d36bed614196b8728c29aaffbc8389190f1ce22" => :yosemite
    sha256 "e86e25a9cbef11232ba463d3d69e6a406dbaffb0553ffcc04bae75e0c7080e3d" => :mavericks
    sha256 "e5d584fc2b9cc29099291a2f4ed29ae200f9cd4ef429e39332aeef412dbffbc9" => :mountain_lion
  end

  option "without-check", "Disable build-time checking"

  depends_on "homebrew/versions/eigen32"
  depends_on "cmake"   => :build
  depends_on "cppunit" => :build
  depends_on "boost"   => :build

  def install
    cd "orocos_kdl" do
      # Removes solvertest from orocos-kdl, as per
      # http://www.orocos.org/forum/rtt/rtt-dev/bug-1043-new-errors-underlying-ik-solver-are-not-correctly-processed
      inreplace "tests/CMakeLists.txt", "ADD_TEST(solvertest solvertest)", "" if build.head?

      mkdir "build" do
        eigen_include_dir = Formula["eigen32"].opt_include/"eigen3"
        args = std_cmake_args << "-DEIGEN3_INCLUDE_DIR=#{eigen_include_dir}"
        args << "-DENABLE_TESTS=ON" if build.with? "check"
        system "cmake", "..", *args
        system "make"
        system "make", "check" if build.with? "check"
        system "make", "install"
      end
    end
  end
end
