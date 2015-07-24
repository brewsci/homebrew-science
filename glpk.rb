class Glpk < Formula
  homepage "https://www.gnu.org/software/glpk/"
  url "http://ftpmirror.gnu.org/glpk/glpk-4.52.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.52.tar.gz"
  sha1 "44b30b0de777a0a07e00615ac6791af180ff4d2c"

  bottle do
    cellar :any
    revision 1
    sha256 "5467bd20c061d10636c32f374ad7c5dc8860d6bf34397151d8b582a673899eab" => :yosemite
    sha256 "413cd402b36f22e10ed189a61ae7b3348e5971468bfd039555fdab11fbe5bd0a" => :mavericks
    sha256 "52662e843e0ebafe16c1d7dd5e852a30aab8d4bc4f77de60ad12055d91fa459e" => :mountain_lion
  end

  depends_on "gmp" => :recommended

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-gmp" if build.with? "gmp"
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOF.undent
    #include "stdio.h"
    #include "glpk.h"

    int main(int argc, const char *argv[])
    {
        printf("%s", glp_version());
        return 0;
    }
    EOF
    system ENV.cc, "test.c", "-lglpk", "-o", "test"
    assert_equal `./test`, version.to_s
  end
end
