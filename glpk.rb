class Glpk < Formula
  desc "Library for Linear (LP) and Mixed-Integer Programming (MIP)"
  homepage "https://www.gnu.org/software/glpk/"
  url "http://ftpmirror.gnu.org/glpk/glpk-4.57.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.57.tar.gz"
  sha256 "7323b2a7cc1f13e45fc845f0fdca74f4daea2af716f5ad2d4d55b41e8394275c"

  bottle do
    cellar :any
    sha256 "68c79bfcdcc6865ccb1aa5c61580ee3a2f06c5c04dfa1f8fe291d0821d69c42d" => :el_capitan
    sha256 "22c65030dd9c59e3d9097b846c939fa037fcb3462a9472310af61ee5e4f7a5ee" => :yosemite
    sha256 "ffddb4dd92cd18457836e76f5cd1c52f4aa231a336063d1072346f929dd3e6cf" => :mavericks
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
    assert_equal `./test`, version.to_s
  end
end
