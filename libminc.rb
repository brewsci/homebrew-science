class Libminc < Formula
  desc "Medical Imaging file format and Toolbox"
  homepage "https://en.wikibooks.org/wiki/MINC"
  url "https://github.com/BIC-MNI/libminc/archive/libminc-2-3-00.tar.gz"
  version "2.3.00"
  sha256 "8c00e0383575ace1f941a5b35b99678db2a0dd5e023f8671d25debc949c7cf12"
  revision 4

  bottle do
    cellar :any
    sha256 "ecf42daf4604e9d779d1c233821d1e9c13cea9491033e783c715c87d21b28b94" => :sierra
    sha256 "81890255c7249f4a9dac832f5d818abdcf3bc93af5953a2b2523b9ada1ed1ab7" => :el_capitan
    sha256 "b1a8d51dd768d4d3f37cbdd7e516b1b461d726bf966f094f8fb5d57c71caf8ac" => :yosemite
    sha256 "35a463f75f1db1473ad9504cc5152c1fa8d5129002ac72e8ba4f4d826ff7b39c" => :x86_64_linux
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
