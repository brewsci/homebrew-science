class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 10
  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "3c140bebc87ef6559aac876d7fb2f72f235473ee0985f17a3d03c717f39f9065" => :sierra
    sha256 "102ffa4727c020ca5924ff3796afbeba33ec01f983cad3e088a7f840003926f5" => :el_capitan
    sha256 "c4f255f3d9556d695b3eb3c87501460102a96c4bd2c82063d63fa4a62ac75101" => :yosemite
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
