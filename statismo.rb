class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 12
  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "13dfd48c58fb42406fb40679f15ca1d60a1a76d01aad268b6cdf94c5d04937df" => :sierra
    sha256 "bb219c06f93368192f51b7ec7ceb1a244195e26cff57891c9d539e7d567e4952" => :el_capitan
    sha256 "0e5d938a43370f1d0d64040705efefd5ffdca224df9db39eb16b5c15fe3139bf" => :yosemite
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
