class Libminc < Formula
  desc "Medical Imaging file format and Toolbox"
  homepage "https://en.wikibooks.org/wiki/MINC"
  url "https://github.com/BIC-MNI/libminc/archive/libminc-2-3-00.tar.gz"
  version "2.3.00"
  sha256 "8c00e0383575ace1f941a5b35b99678db2a0dd5e023f8671d25debc949c7cf12"
  revision 5

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "netcdf"

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
