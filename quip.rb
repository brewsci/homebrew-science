require 'formula'

class Quip < Formula
  homepage 'http://homes.cs.washington.edu/~dcjones/quip/'
  url 'http://homes.cs.washington.edu/~dcjones/quip/quip-1.1.8.tar.gz'
  sha1 '686af763dce1ae29a59bcff8ddab4dc2d6c7c33f'

  def install
    system './configure', '--disable-debug', '--disable-dependency-tracking',
      "--prefix=#{prefix}"
    system 'make', 'install'
  end

  test do
    system 'quip --version'
  end
end
