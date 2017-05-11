class H5utils < Formula
  desc "Utilities to work with scientific data in HDF5"
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz"
  sha256 "7290290ca5d5d4451d757a70c86baaa70d23a28edb09c951b6b77c22b924a38d"
  revision 6

  bottle do
    sha256 "2bffedf786d2c3212d002528fe56f00bc055222c5128db5078c742e9881417d0" => :sierra
    sha256 "b7ddef2444b998a9a7a0245cc6998299142f844b72df77b8d0954592231d698b" => :el_capitan
    sha256 "e7c3dc64b3b0c91b62937b0105d52c2bffd7905ea7545492b1da8622f56668e0" => :yosemite
    sha256 "c6b9472da5336e8a609aef98f3414e220ea79bb844f6d61ce67bce8b9ff38f86" => :x86_64_linux
  end

  depends_on "libpng"
  depends_on "hdf5"

  # A patch is required in order to build h5utils with libpng 1.5
  patch :p0 do
    url "https://trac.macports.org/export/102291/trunk/dports/science/h5utils/files/patch-writepng.c"
    sha256 "b8737b5e4cd6597570b39ce911ffea5bd0173e0e7a6b32620df188b2d260280f"
  end

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
