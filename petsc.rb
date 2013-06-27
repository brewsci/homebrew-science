require 'formula'

class Petsc < Formula
  homepage 'http://www.mcs.anl.gov/petsc/index.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.3-p5.tar.gz'
  sha1 'ac8e64b1b266c3b8779a6dd91f21e09cf3442321'

  depends_on :mpi => :cc
  depends_on :fortran

  def install
    ENV.deparallelize
    system "./configure", "--with-debugging=0", "--prefix=#{prefix}"
    system "make all"
    system "make test"
    system "make install"
  end
end
