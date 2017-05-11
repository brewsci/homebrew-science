class H5utils < Formula
  desc "Utilities to work with scientific data in HDF5"
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz"
  sha256 "7290290ca5d5d4451d757a70c86baaa70d23a28edb09c951b6b77c22b924a38d"
  revision 6

  bottle do
    sha256 "5c79ffbd0c9b8d29331a5e5069dffd96a7e2e2ccad4c53b3366c9863905bf961" => :sierra
    sha256 "7338ea86c1a485288bae837ba8deb84420b7f03a1241e4952c97d14847e81d4a" => :el_capitan
    sha256 "08070af5d7ee84bf3f90559b8c2a3e66a59ec8000486f593501d0c3d43ca1936" => :yosemite
    sha256 "434ce81730b671432dfb9860f5d9c80c8adeab6e0bac48978cab0fb0af909b34" => :x86_64_linux
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
