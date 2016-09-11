class Libminc < Formula
  desc "Medical Imaging file format and Toolbox"
  homepage "https://en.wikibooks.org/wiki/MINC"
  url "https://github.com/BIC-MNI/libminc/archive/libminc-2-3-00.tar.gz"
  version "2.3.00"
  sha256 "8c00e0383575ace1f941a5b35b99678db2a0dd5e023f8671d25debc949c7cf12"
  revision 1

  bottle do
    cellar :any
    sha256 "72e256ea5677480fd5e550461cf0d80e3bf25e110cdc41160ae1fc2061a15470" => :el_capitan
    sha256 "a831cd8f9afae60c1631d82527a7d59eabb0e37c467e4d43715fe68f5dfb9a73" => :yosemite
    sha256 "e96e804abdb88988bd1d833352c7deea0637e17ea85cbac1c838126290956a3c" => :mavericks
  end

  depends_on "hdf5"
  depends_on "netcdf"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{libexec}"
    system "make", "install"

    lib.mkdir
    ln_sf Dir["#{libexec}/lib/*.a"], lib
    ln_sf Dir["#{libexec}/lib/*.dylib"], lib

    include.mkdir
    ln_sf Dir["#{libexec}/includebrew "], include

    cd "testdir" do
      system "cmake", "."
    end

    pkgshare.install "testdir"
  end

  test do
    cp_r "#{pkgshare}/testdir/.", testpath
    system "./minc2-datatype-test"
  end
end
