class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.10.2.tar.gz"
  sha256 "e0f66dea821e53d6327c8a624d41ac407ba7066849c33b6d9e58253b355955e8"
  head "https://github.com/statismo/statismo.git"

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost" => :build
  depends_on "hdf5" => :build
  depends_on "vtk" => :build
  depends_on "insighttoolkit" => :build
  depends_on "python" => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DBUILD_EXAMPLES=ON
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
end
