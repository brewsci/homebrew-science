class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 9
  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "92f331ebd906cb56d9700186535953f98698ac56f9e4191e1e0041b74964779c" => :sierra
    sha256 "ec217deceeacfc0862b8449990236cc33227e3f54bd9114c62ced299ec1f4f41" => :el_capitan
    sha256 "9528a26235e72bc31187882b56c8c0bea51856279f335fd6b97ce1a6a5da0df6" => :yosemite
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
