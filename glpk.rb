class Glpk < Formula
  desc "Library for Linear (LP) and Mixed-Integer Programming (MIP)"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftpmirror.gnu.org/glpk/glpk-4.60.tar.gz"
  mirror "https://ftp.gnu.org/gnu/glpk/glpk-4.60.tar.gz"
  sha256 "1356620cb0a0d33ac3411dd49d9fd40d53ece73eaec8f6b8d19a77887ff5e297"

  bottle do
    cellar :any
    sha256 "6e8074de7e8208178e2f60948e5d938d9d5f8f256323ef7846294d5888ec269c" => :sierra
    sha256 "33d07d0c1f0fb2350e2d1efbbd31115cc590c7367ae3d2cf3390928261015a60" => :el_capitan
    sha256 "c9e2ac11b4bfc18f0ec86572c4b368239366242086bc485e79333bebebfaef36" => :yosemite
    sha256 "5a3a441f6b0b07e17cc933b40cf24f231f332021f03258e95aba9d8653784dc2" => :mavericks
    sha256 "4048de9e46db1bcc7e10a96cce052c7b7bb7d13b38ca25d741cdec1f265ded7b" => :x86_64_linux
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
