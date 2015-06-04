class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  head "https://github.com/statismo/statismo.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "916a4135113d9842866fbbca9c26ba2a229f25dd9914e101524406dac51b718f" => :yosemite
    sha256 "0fb090a76886999f7c6d85b1227ca140e7d4f4827b411ecee7b1610c1128f5f1" => :mavericks
    sha256 "f23c9e5f546976c09788339255e3b37544f1f6eddae5367dd56c74d920b58956" => :mountain_lion
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
