class H5utils < Formula
  desc "Utilities to work with scientific data in HDF5"
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "https://github.com/stevengj/h5utils/releases/download/1.13/h5utils-1.13.tar.gz"
  sha256 "7e8b05942908975455e81e12b0dcbc7bc12e9560c29d5203fce3b25d7de6e494"

  bottle do
    sha256 "6b79b2f0f8fbc80d3dc7a1a43317395d1dd028ca6377a57f1d21f351e30b70e0" => :high_sierra
    sha256 "8079e440932dc13843355b27ddbd4ced1fc3a265c3e1f63ba31d9836eec84af9" => :sierra
    sha256 "79d0ea1d7276637a7b1942431ba891e98c1d2947dc02334fdbdbf709841ed6eb" => :el_capitan
    sha256 "c96c7bd3f3b8be4c90b21f478db1ce05fd62a6c7bcd8cbe9fa14835593bede57" => :x86_64_linux
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
