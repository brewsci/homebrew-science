class Xbyak < Formula
  desc "Header file for dynamic assembly: x86(IA32), x64(AMD64, x86-64) mnemonic"
  homepage "http://herumi.in.coocan.jp"
  url "https://github.com/herumi/xbyak/archive/v5.53.tar.gz"
  sha256 "5685a283573e35a3791be2bb80c301e810c6e3fcba29dd4740154fc73ee3f490"
  head "https://github.com/herumi/xbyak.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "744b9153333bc23a5fe778402cf93a77b9b8039b0bf8f38bfd37c058fb1e269d" => :sierra
    sha256 "744b9153333bc23a5fe778402cf93a77b9b8039b0bf8f38bfd37c058fb1e269d" => :el_capitan
    sha256 "744b9153333bc23a5fe778402cf93a77b9b8039b0bf8f38bfd37c058fb1e269d" => :yosemite
    sha256 "9fb000c7df3a2e283c5dd42434c302367583f310d80bee94c85e1b001dad4ac1" => :x86_64_linux
  end

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
