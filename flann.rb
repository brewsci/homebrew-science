class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  revision 2

  bottle do
    cellar :any
    sha256 "43b078abc69b5a504a4b363096873a74a739fbde53770ee4375262a874dd4603" => :sierra
    sha256 "7ed4462ab4e5d934e4215676737059b827332dca97102ff2337074de07aa1435" => :el_capitan
    sha256 "009143678d2a847c34fce8d77d3abf3e7aa80b05dffbae71d649beacca412a0d" => :yosemite
    sha256 "68c5f1861d2771e71df196a18a10584af2a852889e84cb786cd2d18e06e44b79" => :x86_64_linux
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
