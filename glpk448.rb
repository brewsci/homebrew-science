class Glpk448 < Formula
  desc "Library for Linear Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "http://ftpmirror.gnu.org/glpk/glpk-4.48.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.48.tar.gz"
  sha256 "abc2c8f895b20a91cdfcfc04367a0bc8677daf8b4ec3f3e86c5b71c79ac6adb1"

  keg_only "This formula installs an older version of the GLPK libraries"

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
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lglpk", "-o", "test"
    assert_equal `./test`, version.to_s
  end
end
