require 'formula'

class Lastz < Formula
  homepage 'http://www.bx.psu.edu/~rsharris/lastz/'
  url 'http://www.bx.psu.edu/miller_lab/dist/lastz-1.02.00.tar.gz'
  sha1 '49680c6e18e2b1a417953107eedf41b2aece974d'

  def install
    system "make"
    bin.install %w(src/lastz src/lastz_D)
  end

  test do
    system "lastz --help"
  end
end
