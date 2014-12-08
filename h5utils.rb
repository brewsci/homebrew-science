require 'formula'

class H5utils < Formula
  homepage 'http://ab-initio.mit.edu/wiki/index.php/H5utils'
  url 'http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz'
  sha1 '1bd8ef8c50221da35aafb5424de9b5f177250d2d'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "ae6942b74ef1419e2d9acfcd6629f7004d852e4c" => :yosemite
    sha1 "38e7a2ba5070d8a5473590c5b0c8df24b5d41a9a" => :mavericks
    sha1 "0fa17a4f9d9fcc79e56332e1888fc1f88747abbe" => :mountain_lion
  end

  depends_on "libpng"
  depends_on 'hdf5'

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
