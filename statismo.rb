class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 9
  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "a62058235dc74756eedbab2cfbe0c298089838a293e33c91dcc67e936b1e26f5" => :sierra
    sha256 "5ea80e39c3c2ac80211c72a61a26a987173827a33da9f2bfbc85ab6b07fd3554" => :el_capitan
    sha256 "1e521e2c92a24d0508f934e99942697ce75b62da64b9634ea6a44c598f7cf146" => :yosemite
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
