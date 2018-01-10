class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "http://www.orocos.org/kdl"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.3.1.tar.gz"
  sha256 "aff361d2b4e2c6d30ae959308a124022eeef5dc5bea2ce779900f9b36b0537bd"
  head "https://github.com/orocos/orocos_kinematics_dynamics.git"

  bottle do
    cellar :any
    sha256 "9974d7baa598a88040a1e810e0b2034aae8322b2c28a08747e1ac559155b32ec" => :sierra
    sha256 "c3c31cbc991a22aebb18dc1bd5ff67c8584d2f6341cd340cf4cedbe826b2b1f1" => :el_capitan
    sha256 "a61a02662fa0108135864ac311141abffd216d14d3a124a5bb1ca88a347e0079" => :yosemite
    sha256 "ff623f0c81b0bcb21d4842ea5d802c08d897a8d9d8af3e7eebdc69e24620199b" => :x86_64_linux
  end

  option "without-test", "Disable build-time checking"
  deprecated_option "without-check" => "without-test"

  depends_on "cmake"   => :build
  depends_on "cppunit" => :build
  depends_on "boost"   => :build
  depends_on "eigen@3.2"

  def install
    cd "orocos_kdl" do
      mkdir "build" do
        eigen_include_dir = Formula["eigen@3.2"].opt_include/"eigen3"
        args = std_cmake_args << "-DEIGEN3_INCLUDE_DIR=#{eigen_include_dir}"
        args << "-DENABLE_TESTS=ON" if build.with? "test"
        system "cmake", "..", *args
        system "make"
        system "make", "check" if build.with? "test"
        system "make", "install"
      end
    end
  end
end
