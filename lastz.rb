require 'formula'

class Lastz < Formula
  homepage 'http://www.bx.psu.edu/~rsharris/lastz/'
  url 'http://www.bx.psu.edu/miller_lab/dist/lastz-1.02.00.tar.gz'
  sha1 '49680c6e18e2b1a417953107eedf41b2aece974d'
  devel do
    url 'http://www.bx.psu.edu/~rsharris/lastz/newer/lastz-1.03.34.tar.gz'
    sha1 'febf450ff44c377ba104dd4e286a848d0b6b2e47'
  end

  def install
    system 'make definedForAll=-Wall'
    bin.install %w(src/lastz src/lastz_D)
  end

  test do
    system 'lastz --help |grep -q lastz'
  end
end
