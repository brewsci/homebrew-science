class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.2.tar.gz"
  sha256 "3cb2860c6040415dd0761ff4cfa062915f65df660c95f6f1fee044c86eddd8a2"
  revision 2

  bottle do
    cellar :any
    sha256 "e6e457a9d5375fcc4a9a5d4770b027e5ef98045e772fad434f47a4892741bab5" => :el_capitan
    sha256 "6a82b56ecb6b72081d1005078c46d29912f3b241fcc15a690a09cdce67cd1ad0" => :yosemite
    sha256 "2676fe9c401eae94d7de2e4b997c9ae84ceb451e3839c781c6f5fe4ce568210d" => :mavericks
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
