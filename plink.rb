require 'formula'

class Plink < Formula
  url 'http://pngu.mgh.harvard.edu/~purcell/plink/dist/plink-1.07-src.zip'
  homepage 'http://pngu.mgh.harvard.edu/~purcell/plink/'
  sha1 'd41a2d014ebc02bf11e5235292b50fad6dedd407'

  fails_with :clang do
    build 503
    cause %q[sets.cpp:771:37: error: redefinition of 'i' with a different type]
  end

  def install
    ENV.deparallelize
    inreplace 'Makefile', 'SYS = UNIX', 'SYS = MAC' if OS.mac?
    system 'make'
    (share+'plink').install %w{test.map test.ped}
    bin.install 'plink'
  end

  test do
    system *%w[plink --help]
  end
end
