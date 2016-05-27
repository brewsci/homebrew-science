class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  head "https://github.com/statismo/statismo.git"
  revision 3

  bottle do
    cellar :any
    sha256 "87dc29eaf143b471f36d6feb416351bbbb094b576e3e23e52fe1bc093efcb9a2" => :el_capitan
    sha256 "6cfa1344f3d31be32ce9be0b8c15cbacac1a217c33391615291e00287b6ae2c1" => :yosemite
    sha256 "4e8337ebd0b3bf9eb5e50c8dc7ebae55f9dd23054b639ab51fabb7e02c209e95" => :mavericks
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
