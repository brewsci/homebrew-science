require 'formula'

class Libccd < Formula
  homepage 'http://libccd.danfis.cz'
  url 'http://libccd.danfis.cz/files/libccd-1.4.tar.gz'
  sha1 'abf924ad6e3f427d58734f67348de23970704cbd'
  head 'https://github.com/danfis/libccd.git'

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include <ccd/polytope.h>
      int main() {
        ccd_pt_t polytope;
        ccdPtInit(&polytope);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-lccd"
    system "./test"
  end
end
