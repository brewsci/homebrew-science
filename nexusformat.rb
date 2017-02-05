class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.3.tar.gz"
  sha256 "e78a116feb2ebd04de31a8d8707c65e8e15a64aa8999a40fea305e3909bd6533"
  revision 3

  bottle do
    cellar :any
    sha256 "eb21d5fbded7b42933c1a66b193ecd563085b87a06aaf3944a3990d4f9463896" => :sierra
    sha256 "8c3c4f6319d53dd7dd54a7225efc2d605b3cf9e57e0c2abfe414c541e10c2552" => :el_capitan
    sha256 "d5a5c89ad5dd6fb00ec7b965a10f9ce8d8d0c67d1ac0d4d4e735d003f0b7eced" => :yosemite
    sha256 "591a26f9ac595a88651d2ef429c823c735a16e24ddcf07b7800957bfd629ca25" => :x86_64_linux
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
