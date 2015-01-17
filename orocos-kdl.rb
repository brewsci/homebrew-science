class OrocosKdl < Formula
  homepage "http://www.orocos.org/kdl"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.3.0.tar.gz"
  sha1 "9f59b44d683fcdf290affd71f8a0179bded0bf1d"
  head "https://github.com/orocos/orocos_kinematics_dynamics.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "8d91fed94891fa2f559bfc0f27673296428fa4e9" => :yosemite
    sha1 "bf713c5acb7ec48d4fea358ec1d4ef082656049b" => :mavericks
    sha1 "c7c1fcadd13a5d7e876c2ec94928085f47530497" => :mountain_lion
  end

  option "without-check", "Disable build-time checking"

  depends_on "eigen"
  depends_on "cmake"   => :build
  depends_on "cppunit" => :build
  depends_on "boost"   => :build

  def install
    cd "orocos_kdl" do
      # Removes solvertest from orocos-kdl, as per
      # http://www.orocos.org/forum/rtt/rtt-dev/bug-1043-new-errors-underlying-ik-solver-are-not-correctly-processed
      inreplace "tests/CMakeLists.txt", "ADD_TEST(solvertest solvertest)", "" if build.head?

      mkdir "build" do
        args = std_cmake_args
        args << "-DENABLE_TESTS=ON" if build.with? "check"
        system "cmake", "..", *args
        system "make"
        system "make", "check" if build.with? "check"
        system "make", "install"
      end
    end
  end
end
