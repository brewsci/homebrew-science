require 'formula'

class Metis < Formula
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz'
  sha1 '4722c647024271540f2adcf83456ebdeb1b7d6a6'

  option :universal

  depends_on 'cmake' => :build

  def install
    ENV.universal_binary if build.universal?
    make_args = ["shared=1", "prefix=#{prefix}"]
    make_args << "openmp=" + ((ENV.compiler == :clang) ? "0" : "1")
    system "make", "config", *make_args
    system "make install"
  end
end
