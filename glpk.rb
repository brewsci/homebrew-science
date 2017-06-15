class Glpk < Formula
  desc "Library for Linear (LP) and Mixed-Integer Programming (MIP)"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftp.gnu.org/gnu/glpk/glpk-4.62.tar.gz"
  mirror "https://ftpmirror.gnu.org/glpk/glpk-4.62.tar.gz"
  sha256 "096e4be3f83878ccf70e1fdb62ad1c178715ef8c0d244254c29e2f9f0c1afa70"

  bottle do
    cellar :any
    sha256 "cdab526a75b70ebd1dcf4f448f35f644100b997107f09e34372638a86e90ba31" => :sierra
    sha256 "0974660ec662eb70d66020075a1f227c4dd611d3093eafd74ba9dd433b16202d" => :el_capitan
    sha256 "7db31c317294d9b9ab13aaa53e0be1f62d9eab121920b1555584c331ec2d97a0" => :yosemite
    sha256 "51711766aba79270e2453aeec2188689c17f61a08368731d93902f3cb00e73e1" => :x86_64_linux
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
