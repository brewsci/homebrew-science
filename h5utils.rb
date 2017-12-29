class H5utils < Formula
  desc "Utilities to work with scientific data in HDF5"
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "https://github.com/stevengj/h5utils/releases/download/1.13/h5utils-1.13.tar.gz"
  sha256 "7e8b05942908975455e81e12b0dcbc7bc12e9560c29d5203fce3b25d7de6e494"

  bottle do
    sha256 "2bffedf786d2c3212d002528fe56f00bc055222c5128db5078c742e9881417d0" => :sierra
    sha256 "b7ddef2444b998a9a7a0245cc6998299142f844b72df77b8d0954592231d698b" => :el_capitan
    sha256 "e7c3dc64b3b0c91b62937b0105d52c2bffd7905ea7545492b1da8622f56668e0" => :yosemite
    sha256 "c6b9472da5336e8a609aef98f3414e220ea79bb844f6d61ce67bce8b9ff38f86" => :x86_64_linux
  end

  depends_on "libpng"
  depends_on "hdf5"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-octave"
    system "make", "install"
  end

  test do
    system bin/"h5fromtxt", "-h"
  end
end
