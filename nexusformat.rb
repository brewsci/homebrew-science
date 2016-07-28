class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.2.tar.gz"
  sha256 "3cb2860c6040415dd0761ff4cfa062915f65df660c95f6f1fee044c86eddd8a2"

  bottle do
    cellar :any
    sha256 "9c321f7ebfa4862fff0ae02f2144a7d14fd80f9e2322f663bbd278688c8274d9" => :el_capitan
    sha256 "3f4a3f513079aa3ee9a80ff6e30139a9519a0e12b78a343d47690f5c8c0c9c66" => :yosemite
    sha256 "6d30387aabb88d7df56ca3226a6d6f2409f57ef0f7f68b3d48798eeaf6e0708e" => :mavericks
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
    cmake_args << "-DENABLE_HDF4=TRUE" if build.with? "homebrew/versions/hdf4"
    cmake_args << "-DHDF4_ROOT=#{Formula["homebrew/versions/hdf4"].opt_prefix}" if build.with? "homebrew/versions/hdf4"
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
