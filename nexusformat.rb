class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.2.tar.gz"
  sha256 "3cb2860c6040415dd0761ff4cfa062915f65df660c95f6f1fee044c86eddd8a2"

  bottle do
    sha256 "bf653a6a446ffdd8a160bfd1e0c41ec8a8baf5e8e49721d02746c960990edf3d" => :el_capitan
    sha256 "73844d522f3d373188810b7efba696e6f53bc09e927675e8cf9467e9742e6d04" => :yosemite
    sha256 "b48d8e0e87d6823537bccaf31f293e16cae79d42537634b1061ff5683905a480" => :mavericks
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "libmxml"
  cxx11dep = build.cxx11? ? ["c++11"] : []
  depends_on "hdf5" => cxx11dep
  depends_on "readline" => :recommended
  depends_on "homebrew/versions/hdf4" => :recommended
  depends_on "doxygen" => :optional
  depends_on "szip" => :linked

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
