class Clblas < Formula
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/v2.2.tar.gz"
  sha256 "0563e028485d240f8b6e6efcae61677049627b19e924dcb1ef8014065b6416df"

  depends_on "cmake" => :build
  depends_on "boost" => :build

  patch do
    # install clBLAS cmake configuration and version files
    url "https://github.com/clMathLibraries/clBLAS/commit/554d61ec834c72b6ce727b9232ecbf9864cf9d8c.diff"
    sha256 "49bd44ef1c2cb6e0e63ab5286d2aa185224a529c04d3d9efff45533c984d6bf8"
  end

  def install
    args = std_cmake_args
    args << "-DBUILD_TEST=OFF"
    args << "-DBUILD_CLIENT=ON"
    args << "-DBUILD_KTEST=OFF"
    args << "-DSUFFIX_LIB:STRING="
    args << "-DCMAKE_MACOSX_RPATH:BOOL=ON"
    system "cmake", "src", *args
    system "make", "install"
  end

  test do
    system "#{bin}/client", "--cpu"
  end
end
