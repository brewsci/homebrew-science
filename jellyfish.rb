require 'formula'

class Jellyfish < Formula
  homepage 'http://www.cbcb.umd.edu/software/jellyfish/'
  url 'ftp://ftp.genome.umd.edu/pub/jellyfish/jellyfish-2.0.0.tar.gz'
  sha1 '65985a197e1fe57fd3965c055616eaafe0a748e8'

  fails_with :clang
  fails_with :llvm
  fails_with :gcc
  fails_with :gcc => '4.3' do
    cause 'gcc >= 4.4 is required to compile Jellyfish.'
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
