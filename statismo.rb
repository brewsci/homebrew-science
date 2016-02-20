class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  head "https://github.com/statismo/statismo.git"
  revision 2

  bottle do
    cellar :any
    sha256 "9f27fa13e22f3e7c6e47048c0410cf33329b56d3f0eab0498c7a3f33dd1801b0" => :el_capitan
    sha256 "3a87e2a46a485b734d52d30c8ee8455775bea1b2f8b705aa1000b999480a101e" => :yosemite
    sha256 "a54ce11f390f164e5839deee20970a4403f29eaa7904797a5259034430a4e041" => :mavericks
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
