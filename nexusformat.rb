class Nexusformat < Formula
  desc "Common data format for neutron, x-ray, and muon science"
  homepage "http://www.nexusformat.org"
  url "https://github.com/nexusformat/code/archive/v4.4.3.tar.gz"
  sha256 "e78a116feb2ebd04de31a8d8707c65e8e15a64aa8999a40fea305e3909bd6533"

  bottle do
    cellar :any
    sha256 "8fd8e35d660a10ef1db85727f305ccb5fc0efba2f9b4289965a90673a9408133" => :el_capitan
    sha256 "6aa32694a36af2896d43c37b9d28468dd0854e03bf289b35db6a4e16660b7aab" => :yosemite
    sha256 "36429a1b29ce778eb09a7bbce599b498e077ac6cd97f54d182a9d9b16fd92157" => :mavericks
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
