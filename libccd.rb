require 'formula'

class Libccd < Formula
  homepage 'http://libccd.danfis.cz'
  url 'http://libccd.danfis.cz/files/libccd-2.0.tar.gz'
  sha1 'f6ab9053c7f3b18a781c8be973c1844c4421936a'
  head 'https://github.com/danfis/libccd.git'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "e75db5205d2a92cf32f26f6a8ab554e80ef583ef" => :yosemite
    sha1 "4b51107e036d27f9613bfce599a3a7e0d521ec52" => :mavericks
    sha1 "2f422e63317729ff3fc34e06f02278c0d955e204" => :mountain_lion
  end

  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include <ccd/vec3.h>
      int main() {
        ccdVec3PointSegmentDist2(
          ccd_vec3_origin, ccd_vec3_origin,
          ccd_vec3_origin, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lccd"
    system "./test"
  end
end
