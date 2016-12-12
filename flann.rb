class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  revision 2

  bottle do
    cellar :any
    sha256 "28b3f85c2ebb0d52a69c2664b39ac73f7793dacc24ab89113db7ec2860e26224" => :el_capitan
    sha256 "071079e66e65e86a2309841462539fe1902b3fec51d6a00edfb99fab6b594f59" => :yosemite
    sha256 "98bcad5710284bdf00ad4c4def62fc39524fc3064b91b39bb289de4f0b44f9f4" => :mavericks
  end

  deprecated_option "enable-matlab" => "with-octave"
  deprecated_option "enable-python" => "with-python"

  option "with-octave", "Enable Matlab/Octave bindings"
  option "without-examples", "Do not build and install example binaries"
  option "with-openmp", "Build with OpenMP support"
  needs :openmp if build.with? "openmp"

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "python" => :optional
  depends_on "octave" => :optional
  depends_on "numpy" => :python if build.with? "python"

  def install
    args = std_cmake_args
    args << "-DBUILD_MATLAB_BINDINGS:BOOL=" + (build.with?("octave") ? "ON" : "OFF")
    args << "-DBUILD_PYTHON_BINDINGS:BOOL=" + (build.with?("python") ? "ON" : "OFF")

    inreplace "CMakeLists.txt", "add_subdirectory( examples )", "" if build.without? "examples"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    if build.with? "examples"
      curl "-O", "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/datasets/dataset.dat"
      curl "-O", "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/datasets/testset.dat"
      system "#{bin}/flann_example_c"
      curl "-O", "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/datasets/dataset.hdf5"
      system "#{bin}/flann_example_cpp"
    end
  end
end
