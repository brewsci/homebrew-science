class Libbuddy < Formula
  desc "binary decision diagram library"
  homepage "https://sourceforge.net/projects/buddy/"
  url "https://downloads.sourceforge.net/project/buddy/buddy/BuDDy%202.4/buddy-2.4.tar.gz"
  sha256 "d3df80a6a669d9ae408cb46012ff17bd33d855529d20f3a7e563d0d913358836"

  bottle do
    cellar :any
    sha256 "5dc396c196d46646102d10c5d3ff32d8b37249cac78af2595417e6474494453b" => :el_capitan
    sha256 "451c34f54e575578a3b3cfaad5e5a860f012317ff32053097c6132bba60a7da9" => :yosemite
    sha256 "f4a66068fc8b53b557e3c9f6be57574c1711aedd91e1f18e2b6c5111b62fdbe7" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include "bvec.h"
      using namespace std;
      int main(void) {
        bdd_init(10, 10);
        bvec x = bvec(1);
        bvec c = bvec(1, 0);
        bdd t = x == c;
        cout << t;
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cc", "-I#{include}", "-L#{lib}", "-lbdd"
    assert_equal "T", shell_output("./test")
  end
end
