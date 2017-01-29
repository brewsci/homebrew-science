class Libminc < Formula
  desc "Medical Imaging file format and Toolbox"
  homepage "https://en.wikibooks.org/wiki/MINC"
  url "https://github.com/BIC-MNI/libminc/archive/libminc-2-3-00.tar.gz"
  version "2.3.00"
  sha256 "8c00e0383575ace1f941a5b35b99678db2a0dd5e023f8671d25debc949c7cf12"
  revision 2

  bottle do
    cellar :any
    sha256 "09c1b3d7ac4110ed65a6a66cffcccf6c0e86124de7a8a54baf67de6f38494eb6" => :sierra
    sha256 "433683a42e968ca068bf0bf7dd09c8619455df69438a08cd4a4d9212c66f0473" => :el_capitan
    sha256 "158311357740145fb20619791592ebbabfa811c02c67eded3ff72fb1544b74c4" => :yosemite
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
