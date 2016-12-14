class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.3.tar.gz"
  sha256 "e78a116feb2ebd04de31a8d8707c65e8e15a64aa8999a40fea305e3909bd6533"
  revision 2

  bottle do
    cellar :any
    sha256 "e23c2a47b9cd1ab498f951e660d8f2d4a15da97999a51fe9f96c1fd3309825de" => :sierra
    sha256 "97bbed92c7aa1d9bb1f5753e4fbf5b9645af370c5837ad6c1f9f6ae2a5d59797" => :el_capitan
    sha256 "edda0f96ca654f020b7ce068a53cdf7de50edb7cfd0d079218275449ec8fc10d" => :yosemite
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
