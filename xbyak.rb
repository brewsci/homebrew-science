class Xbyak < Formula
  desc "Header file for dynamic assembly: x86(IA32), x64(AMD64, x86-64) mnemonic"
  homepage "http://herumi.in.coocan.jp"
  url "https://github.com/herumi/xbyak/archive/v4.70.tar.gz"
  sha256 "158b6b43792361314226b11a27678a62b2dd3229ae34f217050501b80e422dc2"
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
