class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 5

  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "3d9a15d196c7f6a3c0cb8e91ba365ec0570bcc24a7e4e495714825795ba4ef48" => :el_capitan
    sha256 "976456139d92c6845a9f64ee44e22fc83baec632e7bad303fd67de876fa775f5" => :yosemite
    sha256 "d8dd32fe80a228af23b5c7c4f8dda41cd8a840aa82b301f20cc41483911db6de" => :mavericks
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
