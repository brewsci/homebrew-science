class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.10.2.tar.gz"
  sha256 "e0f66dea821e53d6327c8a624d41ac407ba7066849c33b6d9e58253b355955e8"
  head "https://github.com/statismo/statismo.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "916a4135113d9842866fbbca9c26ba2a229f25dd9914e101524406dac51b718f" => :yosemite
    sha256 "0fb090a76886999f7c6d85b1227ca140e7d4f4827b411ecee7b1610c1128f5f1" => :mavericks
    sha256 "f23c9e5f546976c09788339255e3b37544f1f6eddae5367dd56c74d920b58956" => :mountain_lion
  end

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
