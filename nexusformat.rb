class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.3.tar.gz"
  sha256 "e78a116feb2ebd04de31a8d8707c65e8e15a64aa8999a40fea305e3909bd6533"
  revision 5

  bottle do
    cellar :any
    sha256 "b2575095c1b6f87a468234b4fc890d480a9533388a0e67c10323fae8d2c5340f" => :sierra
    sha256 "9cb320d4b1fbc315e8711cca321826e29ba607f396d48fe6de5d311915de1796" => :el_capitan
    sha256 "fb61734329a3caaa89110de7ea11f53b206c18ec5364e99c70a0658ed3d456b9" => :yosemite
    sha256 "9db7702bc8afa2bdeb59d8efb6d6325dd7cf2e378f200a2df5713729465afaee" => :x86_64_linux
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
