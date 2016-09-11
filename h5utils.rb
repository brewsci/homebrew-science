class H5utils < Formula
  desc "Utilities to work with scientific data in HDF5"
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz"
  sha256 "7290290ca5d5d4451d757a70c86baaa70d23a28edb09c951b6b77c22b924a38d"
  revision 4

  bottle do
    sha256 "53e09efdef87074bd12c9aa66ed092d681db3c1438a8541b06f36466240a737e" => :el_capitan
    sha256 "44beb91faf69855c4484a7f0772f5ed150f20740080c59ea04fd54835faa1df4" => :yosemite
    sha256 "7ca32452c0351f5593078c270f9d517a3ce318ea3f46ec93b94a0e57d318e91b" => :mavericks
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
end
