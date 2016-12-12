class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.3.tar.gz"
  sha256 "e78a116feb2ebd04de31a8d8707c65e8e15a64aa8999a40fea305e3909bd6533"
  revision 2

  bottle do
    cellar :any
    sha256 "8842f1cdb80a0b9ad2ef328e65c900f4232ed4c3a06f21dd4feeb27b12b5ab18" => :sierra
    sha256 "a9b03b655466ff438801625d934800000e8421943709b04b5aff86ce835a8818" => :el_capitan
    sha256 "909d6135a481eb51ed35addb71019917239fd308d889ce16b4d8a17f058bbeda" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "libmxml"
  cxx11dep = build.cxx11? ? ["c++11"] : []
  depends_on "hdf5" => cxx11dep
  depends_on "readline" => :recommended
  depends_on "homebrew/versions/hdf4" => :recommended
  depends_on "doxygen" => :optional

  def install
    ENV.cxx11 if build.cxx11?
    cmake_args = std_cmake_args
    cmake_args << "-DENABLE_APPS=TRUE"
    cmake_args << "-DENABLE_CXX=TRUE"
    cmake_args << "-DENABLE_MXML=TRUE"
    cmake_args << "-DENABLE_HDF4=TRUE" if build.with? "hdf4"
    system "cmake", ".", *cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/nxdir"
  end
end
