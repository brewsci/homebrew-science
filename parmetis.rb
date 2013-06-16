require 'formula'

class Parmetis < Formula
  homepage 'http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview'
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz'
  sha1 'e0df69b037dd43569d4e40076401498ee5aba264'

  depends_on 'cmake' => :build
  depends_on :mpi => :cc

  def install
    system "make", "config", "prefix=#{prefix}"
    system 'make install'
  end
end
