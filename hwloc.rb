require 'formula'

class Hwloc < Formula
  homepage 'http://www.open-mpi.org/projects/hwloc/'
  url "http://www.open-mpi.org/software/hwloc/v1.9/downloads/hwloc-1.9.tar.bz2"
  sha1 "99646446502e0f9952170bf1082be63361d99b6d"

  depends_on 'pkg-config' => :build
  depends_on 'cairo' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
