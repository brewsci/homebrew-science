class H5utils < Formula
  desc "Utilities to work with scientific data in HDF5"
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz"
  sha256 "7290290ca5d5d4451d757a70c86baaa70d23a28edb09c951b6b77c22b924a38d"
  revision 4

  bottle do
    sha256 "52fc5f35fa4a93bc60351f618d855499c877a8cea579e1b477521c396fd0fc16" => :el_capitan
    sha256 "0c02b998dbd3525838d15b6ef6d6cbd66edc5bd0b403b903d5afc726451180b8" => :yosemite
    sha256 "f5c1be3e6d4279e64cd0a12970e81d624b0ea168ec54bc51005a9e1ad69129b4" => :mavericks
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
