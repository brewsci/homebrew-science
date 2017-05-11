class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.3.tar.gz"
  sha256 "e78a116feb2ebd04de31a8d8707c65e8e15a64aa8999a40fea305e3909bd6533"
  revision 5

  bottle do
    cellar :any
    sha256 "81685de01b2a1ec7b25351e23f871986bd6d711a77f0505be68b435fa52b465a" => :sierra
    sha256 "0628f4477e6b700aee3789bdbe9479b782fff227bf96c4af146f84acc27f0a3f" => :el_capitan
    sha256 "7b152e2017515025dfcaf55d823b3aec8c1a0a98ed492f4272228d9155c90615" => :yosemite
    sha256 "a43726cb9979ac0d2628fbff5c1fb4e28e8005ed1225bee1fbebab6863cac6e8" => :x86_64_linux
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "libmxml"
  cxx11dep = build.cxx11? ? ["c++11"] : []
  depends_on "hdf5" => cxx11dep
  depends_on "readline" => :recommended
  depends_on "hdf@4" => :recommended
  depends_on "doxygen" => :optional

  def install
    ENV.cxx11 if build.cxx11?
    cmake_args = std_cmake_args
    cmake_args << "-DENABLE_APPS=TRUE"
    cmake_args << "-DENABLE_CXX=TRUE"
    cmake_args << "-DENABLE_MXML=TRUE"
    cmake_args << "-DENABLE_HDF4=TRUE" if build.with? "hdf@4"
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
