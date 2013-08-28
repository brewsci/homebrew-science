require 'formula'

class Metis < Formula
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz'
  sha1 '4722c647024271540f2adcf83456ebdeb1b7d6a6'

  option :universal

  depends_on 'cmake' => :build

  def install
    ENV.universal_binary if build.universal?
    system "make", "config", "prefix=#{prefix}"
    system "make install"
  end
end
