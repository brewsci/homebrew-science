class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.3.tar.gz"
  sha256 "e78a116feb2ebd04de31a8d8707c65e8e15a64aa8999a40fea305e3909bd6533"
  revision 6

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "ef2a356e9fa98b6efb9333e88ff242195cfa0d8af703942aedbba0b405f42981"
    sha256 cellar: :any, el_capitan:   "cbe9d5e6f3f04f4783b38a194490ab9dda157df6b6b59a19d878cb5e5dd4d05b"
    sha256 cellar: :any, yosemite:     "fdefd7b6eaf73614fe95ac88f0f5821a708d6dafb62a2a50308c48aaa8a2ecd1"
    sha256 cellar: :any, x86_64_linux: "8db4ec51ef6966dc74e83b634b79af57379fbd6d6890646d58b54da61e910104"
  end

  deprecated_option "hdf@4" => "hdf4"

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "libmxml"
  depends_on "hdf4" => :recommended
  depends_on "readline" => :recommended
  depends_on "doxygen" => :optional

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DENABLE_APPS=TRUE"
    cmake_args << "-DENABLE_CXX=TRUE"
    cmake_args << "-DENABLE_MXML=TRUE"
    cmake_args << "-DENABLE_HDF4=TRUE" if build.with? "hdf4"
    system "cmake", ".", *cmake_args
    system "make"
    # enable once test failures are resolved upstream
    # https://github.com/nexusformat/code/issues/443
    # system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/nxdir"
  end
end
