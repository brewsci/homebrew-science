class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 5

  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "eefd70a8a8e7fce1f7e924090fddebbb5c0c1be45e6803077485d2bc16fbb0a0" => :el_capitan
    sha256 "134e0ebd076764d11bd69b2078e1997e8c19c93b521bc11a742740c6c978a508" => :yosemite
    sha256 "e5e509e49d9ac6ff00c32fb49e8200cb2ed12b6586b3f299acaf5cb606519a82" => :mavericks
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
