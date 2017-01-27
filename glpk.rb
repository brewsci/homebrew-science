class Glpk < Formula
  desc "Library for Linear (LP) and Mixed-Integer Programming (MIP)"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftpmirror.gnu.org/glpk/glpk-4.61.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.61.tar.gz"
  sha256 "9866de41777782d4ce21da11b88573b66bb7858574f89c28be6967ac22dfaba9"

  bottle do
    cellar :any
    sha256 "4f03fce647763acf07b4d7b158fc1c10d324ccc3e3536cd8f3cf3fcfbe312d13" => :sierra
    sha256 "13e284d8a723a54617ffa3f61114070833d7d6b21848fecdfe6a1175893bbebc" => :el_capitan
    sha256 "4a9997de364745c6a6c063773078a9e34865a81aea65c45d8443f01794fd5798" => :yosemite
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
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lglpk", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
