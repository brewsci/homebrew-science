require "formula"

class OrocosKdl < Formula
  homepage "http://www.orocos.org/kdl"

  stable do
    url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.2.2.tar.gz"
    sha1 "cfd18664a615c2babde96fb839b9bbc5dcd7a3ff"
    depends_on "eigen2"
  end

  head do
    url "https://github.com/orocos/orocos_kinematics_dynamics.git"
    depends_on "eigen"
  end

  option "with-check", "Enable build-time checking (requires that cppunit was built with gcc)"

  depends_on "cmake"   => :build
  depends_on "cppunit" => :build if build.with? "check"

  fails_with :clang do
    build 503
    cause <<-EOS.undent
      More information at this webpage:
      http://answers.ros.org/question/94771/building-ros-on-osx-109-solution/
      which says that a patch has been submitted upstream.
    EOS
  end

  def install
    cd "orocos_kdl"

    # Removes solvertest from orocos-kdl, as per
    # http://www.orocos.org/forum/rtt/rtt-dev/bug-1043-new-errors-underlying-ik-solver-are-not-correctly-processed
    inreplace "tests/CMakeLists.txt", "ADD_TEST(solvertest solvertest)", "" if build.head?

    mkdir "build" do
      args = std_cmake_args
      args << "-DENABLE_TESTS=ON" if build.with? "check"
      system "cmake", "..", *args
      system "make"
      system "make check" if build.with? "check"
      system "make install"
    end
  end
end
