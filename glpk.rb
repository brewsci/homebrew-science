class Glpk < Formula
  homepage "https://www.gnu.org/software/glpk/"
  url "http://ftpmirror.gnu.org/glpk/glpk-4.52.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.52.tar.gz"
  sha1 "44b30b0de777a0a07e00615ac6791af180ff4d2c"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "0ccfb05a60ae7ddbc9c53d5333b0a51b3e86694e" => :yosemite
    sha1 "da31c189499c716772e13ec8037ae896d01866ab" => :mavericks
    sha1 "0d02d5430580f440c1477996dffa596871931796" => :mountain_lion
  end

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
