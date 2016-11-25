class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 7

  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "a0e1bcb53abc1c893fa3e7d25c3c361e19cb32aabe643b0a3ab5a6876c4693b4" => :sierra
    sha256 "965299455da79725beb421ea7a2cc2e5731ecfb7e7e9219d01cc9dd484cd123e" => :el_capitan
    sha256 "25e8b08b8536d6e0c68cad5b0e56d7e22abf698cf8e97403089bdf4958f6141c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "boost"
  depends_on "hdf5"
  depends_on "vtk"
  depends_on "insighttoolkit"

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DBUILD_EXAMPLES=ON
      -DBUILD_CLI_TOOLS=ON
      -DBUILD_DOCUMENTATION=OFF
      -DVTK_SUPPORT=ON
      -DITK_SUPPORT=ON
    ]
    args << ".."

    mkdir "statismo-build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/statismo-build-shape-model", "--help"
  end
end
