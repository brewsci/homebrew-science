class Statismo < Formula
  desc "Framework for building statistical image And shape models"
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  revision 12
  head "https://github.com/statismo/statismo.git"

  bottle do
    cellar :any
    sha256 "d4423108dae87f2b48042ff0ade06ee6f516a6338ae519f465a57d4e04cd14ca" => :sierra
    sha256 "db01686061a8f625f179eba918ca149e4368223e40e28b86263748cec72426de" => :el_capitan
    sha256 "9765569d539d532ee54c0b9acf4b602c62b03fadbc96896060227a613f970f2c" => :yosemite
    sha256 "a3d0613b204d731ad06c9e5bdd6625a998c851ffb53a22689c1bb1c74403290c" => :x86_64_linux
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
