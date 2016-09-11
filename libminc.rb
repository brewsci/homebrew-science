class Libminc < Formula
  desc "Medical Imaging file format and Toolbox"
  homepage "https://en.wikibooks.org/wiki/MINC"
  url "https://github.com/BIC-MNI/libminc/archive/libminc-2-3-00.tar.gz"
  version "2.3.00"
  sha256 "8c00e0383575ace1f941a5b35b99678db2a0dd5e023f8671d25debc949c7cf12"
  revision 1

  bottle do
    cellar :any
    sha256 "442acf723664a80819ae54084ca12798e43a3d10c4728048eb00da0f54a22843" => :el_capitan
    sha256 "f2d8899672051becea325fd8746ac07247cb87744c0cf020b860b58abaf62b8c" => :yosemite
    sha256 "bb2be56b80d571d5287c4e8abd6289f766f8b6b7c1a0ab925d587f8f7a747509" => :mavericks
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
