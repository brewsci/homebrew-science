class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  head "https://github.com/statismo/statismo.git"
  revision 2

  bottle do
    cellar :any
    sha256 "87eac4d9730259f87a745b7cd80c8014d840cdf65f90d48d10a66e00b20bc991" => :el_capitan
    sha256 "590124b4ebd7d225983ee33a035493dc7ea96987c0918e582378fc98ea38d13f" => :yosemite
    sha256 "8f9979a6053ebc291109230dcfccc76006b0844f62b4a845e279ad7387241584" => :mavericks
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
