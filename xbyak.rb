class Xbyak < Formula
  desc "Header file for dynamic assembly: x86(IA32), x64(AMD64, x86-64) mnemonic"
  homepage "http://herumi.in.coocan.jp"
  url "https://github.com/herumi/xbyak/archive/v5.53.tar.gz"
  sha256 "5685a283573e35a3791be2bb80c301e810c6e3fcba29dd4740154fc73ee3f490"
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
