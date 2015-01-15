class Glpk < Formula
  homepage "https://www.gnu.org/software/glpk/"
  url "http://ftpmirror.gnu.org/glpk/glpk-4.52.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.52.tar.gz"
  sha1 "44b30b0de777a0a07e00615ac6791af180ff4d2c"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
