require "formula"

class Xbyak < Formula
  homepage "http://homepage1.nifty.com/herumi/soft/xbyak_e.html"
  url "https://github.com/herumi/xbyak/archive/v4.70.tar.gz"
  sha1 "a56246e87df6c0e9f750eff0b34f8dc2d26ac5cc"
  head "https://github.com/herumi/xbyak.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath / "test.cpp").write <<-EOS.undent
      #include <stdio.h>
      #include <xbyak/xbyak.h>

      class Sample : public Xbyak::CodeGenerator {
      public:
          Sample(int n)
          {
              mov(ecx, n); // -- (A)
              xor(eax, eax); // sum
              test(ecx, ecx);
              jbe("exit");
              xor(edx, edx); // i
          L("lp");
              add(eax, edx);
              inc(edx);
              cmp(edx, ecx);
              jbe("lp");
          L("exit");
              ret();
          }
      };
      int main(int argc, char *argv[])
      {
          int n = 100;
          Sample s(n);
          printf("1 + ... + %d = %d\\n", n, ((int (*)())s.getCode())());
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-fno-operator-names", "-pedantic", "-o", "test"
    system "./test"
  end
end
