class H5utils < Formula
  desc "Utilities to work with scientific data in HDF5"
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz"
  sha256 "7290290ca5d5d4451d757a70c86baaa70d23a28edb09c951b6b77c22b924a38d"
  revision 4

  bottle do
    rebuild 1
    sha256 "bbdce6ed4a6a703ae178c4eb18854d0ffeb7911650510dcaedc5c40da0a1c187" => :sierra
    sha256 "7904dc446b703b96961290f5061150a3ef411dadd23c326804b5f0f1a22a7cde" => :el_capitan
    sha256 "6d669553e5e9f180624b98413c8598b75c90adc1d82b23d8993f27873624b3e2" => :yosemite
    sha256 "6a73fa616362d914344713a318afcd0b6cdc21b25ba33797e9220f5853d15ff8" => :x86_64_linux
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
