require 'formula'

class Mathomatic < Formula
  homepage 'http://www.mathomatic.org/'
  url 'http://mathomatic.orgserve.de/mathomatic-16.0.5.tar.bz2'
  sha1 'aaaf4df4aa3dc9ea748211278e657c2195858c24'

  head do
    url 'http://mathomatic.orgserve.de/am.tar.bz2'
    sha1 '6fc3c6c265d1f0314fb622b57c8202d1ab4c46f9'
  end

  def install
    ENV['prefix'] = prefix
    system "make READLINE=1"
    system "make m4install"
    cd 'primes' do
      system 'make'
      system 'make install'
    end
  end
end
