class Clblas < Formula
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/v2.2.tar.gz"
  sha256 "0563e028485d240f8b6e6efcae61677049627b19e924dcb1ef8014065b6416df"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "95e08bbfde36c49f8f4fae3f420980d329c67215f7198475f34a0bae22a05f4f" => :yosemite
    sha256 "0315da2f6b54edfff65315709f2d16cc9c9514adafa2ea7400b6a759f16001c1" => :mavericks
    sha256 "665bd59d4dc12933722003a7092eea19104ef5722aacfdc27e423c988df0f5ca" => :mountain_lion
  end

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
