require "formula"

class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.10.1.tar.gz"
  sha1 "b42f67ea25ffacfe6a769aefb0c71400512a1923"
  head 'https://github.com/statismo/statismo.git'

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "boost" => :build
  depends_on "hdf5" => :build
  depends_on "vtk" => :build
  depends_on "insighttoolkit" => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=ON
      -DVTK_SUPPORT=ON
      -DITK_SUPPORT=ON
    ]
    args << ".."

    mkdir 'statismo-build' do
      system "cmake", *args
      system "make", "install"
    end
  end
end
