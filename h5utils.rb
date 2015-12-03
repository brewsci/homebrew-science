require "formula"

class H5utils < Formula
  homepage "http://ab-initio.mit.edu/wiki/index.php/H5utils"
  url "http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz"
  sha256 "7290290ca5d5d4451d757a70c86baaa70d23a28edb09c951b6b77c22b924a38d"
  revision 3

  bottle do
    sha256 "b77085fa8a924749a6d9dee2b8319a00d39d5a9d097d1e25c6aad6ade800ed1c" => :el_capitan
    sha256 "02e68a979c867d08dab3e90ba0f1afab5c7d5ddbf04238e856e1db2584998187" => :yosemite
    sha256 "f809a9cd94cc8fca03d74deeef9e41994ad1dcd6b304b98169d4e34b62e9500c" => :mavericks
  end

  depends_on "libpng"
  depends_on "hdf5"

  # A patch is required in order to build h5utils with libpng 1.5
  patch :p0 do
    url "https://trac.macports.org/export/102291/trunk/dports/science/h5utils/files/patch-writepng.c"
    sha1 "026aa59f2e13388d0b7834de6dcbd48da2858cbe"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-octave"
    system "make install"
  end
end
