class Flann < Formula
  desc "FLANN - Fast Library for Approximate Nearest Neighbors"
  homepage "http://www.cs.ubc.ca/~mariusm/index.php/FLANN/FLANN"
  url "http://people.cs.ubc.ca/~mariusm/uploads/FLANN/flann-1.8.4-src.zip"
  sha256 "dfbb9321b0d687626a644c70872a2c540b16200e7f4c7bd72f91ae032f445c08"
  revision 1

  bottle do
    cellar :any
    sha256 "ca40319fa78946b322841b9ce208f5c10e28e03e5a4913cd270538b80ee78b2e" => :yosemite
    sha256 "fa19463e2515be50e21b6204ffef67ae6147ba9adcc609aefcfc37a541cdcb0a" => :mavericks
    sha256 "1c403208c33bfef7484d1adc23438b293aff7cd49f54c41f8fd821fb66658e92" => :mountain_lion
  end

  deprecated_option "enable-matlab" => "with-octave"
  deprecated_option "enable-python" => "with-python"

  option "with-octave", "Enable Matlab/Octave bindings"
  option "without-examples", "Do not build and install example binaries"

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
    end
  end
end
