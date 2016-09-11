class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.2.tar.gz"
  sha256 "3cb2860c6040415dd0761ff4cfa062915f65df660c95f6f1fee044c86eddd8a2"
  revision 2

  bottle do
    cellar :any
    sha256 "661bcf8a263f4118347657d317264ff2c729da539e7686e7a6d589e2daf7c0bc" => :el_capitan
    sha256 "503248f884f7c9377b87bcff6fb0f8dd8b793ac02b3fdd524670f9cf2a2b7384" => :yosemite
    sha256 "9015e38f6fa2fab94030e33b52ffd7cc23507e2bf87da37bbab0c1e49fc43aa7" => :mavericks
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "libmxml"
  cxx11dep = build.cxx11? ? ["c++11"] : []
  depends_on "hdf5" => cxx11dep
  depends_on "readline" => :recommended
  depends_on "homebrew/versions/hdf4" => :recommended
  depends_on "doxygen" => :optional

  # C++ API fails to build after selecting the C++11 or later standard.
  # https://github.com/nexusformat/code/pull/435
  patch do
    url "https://github.com/nexusformat/code/pull/435.patch"
    sha256 "bfc20b4d112a4ccb69dd8755dc78fead1e4c12c01d623c6ece5870ad29ab5f17"
  end

  def install
    ENV.cxx11 if build.cxx11?
    cmake_args = std_cmake_args
    cmake_args << "-DENABLE_APPS=TRUE"
    cmake_args << "-DENABLE_CXX=TRUE"
    cmake_args << "-DENABLE_MXML=TRUE"
    cmake_args << "-DENABLE_HDF4=TRUE" if build.with? "hdf4"
    system "cmake", ".", *cmake_args
    system "make"
    # test failures have been reported upstream
    # https://github.com/nexusformat/code/issues/426
    # system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/nxdir"
  end
end
