class Clblas < Formula
  desc "Library containing BLAS functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/v2.6.tar.gz"
  sha256 "4607561a648949709bc7c368be4aaf7346174406e678454b643e31cfe861830c"

  bottle do
    cellar :any
    sha256 "c2390d3ccd264c755b529dda21016583fa60dd8f8c1f30502ec22d73d55ef4ff" => :el_capitan
    sha256 "fcaafc49c3123705e90b836902133e481859dd40140636317088326e8c22da98" => :yosemite
    sha256 "bc59a237799fa5a1d880f39f5caa96abed14bf407bd4db222a87109c1947e7bd" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build

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
    system "#{bin}/clBLAS-client", "--cpu"
  end
end
