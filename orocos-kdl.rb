class OrocosKdl < Formula
  homepage "http://www.orocos.org/kdl"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.3.0.tar.gz"
  sha256 "7be2dd5e4f4c1ceac2cdf1f4fae3d94d4ffd9fc1af8d483c05f04e80ef84b3f9"
  revision 1
  head "https://github.com/orocos/orocos_kinematics_dynamics.git"

  bottle do
    cellar :any
    sha256 "f6c826d3fd4ac6e5cf2e3850b5eaf7caccbf24f0143c6c8b9cc01ed3ed0509b6" => :sierra
    sha256 "2dfa94597ae2f68f5796b9651277c13c30c02cbe1b5998518771fb47378ee024" => :el_capitan
    sha256 "4dcf30a9d7864fb6366736f8b267094497177a7cc8161234e73685447b0e105c" => :yosemite
    sha256 "81e21e00a11b6e9a6b67361d5729da5cec76799bd700d31480bfb655ffe6c122" => :x86_64_linux
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
