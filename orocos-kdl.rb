class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "http://www.orocos.org/kdl"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.3.1.tar.gz"
  sha256 "aff361d2b4e2c6d30ae959308a124022eeef5dc5bea2ce779900f9b36b0537bd"
  head "https://github.com/orocos/orocos_kinematics_dynamics.git"

  bottle do
    cellar :any
    sha256 "bdd3f727f1f4014d20fbe4f81e46053013acc30ec47484da177d1c9a65108e12" => :sierra
    sha256 "a869c3845a9738c588288a98d4afee923e9f0b331b08085c1efbce90b7b50050" => :el_capitan
    sha256 "85ace504eb2aa77cb06d0dba7cbb4e8fe166e135ee3ac4c8add779b1f0625242" => :yosemite
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
