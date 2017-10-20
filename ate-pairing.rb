class AtePairing < Formula
  desc "Implements Optimal Ate Pairing over Barreto-Naehrig Curves"
  homepage "https://github.com/herumi/ate-pairing"
  url "https://github.com/herumi/ate-pairing/archive/v1.2.tar.gz"
  sha256 "04450727f00d58bee07dea7fad04a39eb12e89b00a9b3e7db78cbbcee9e61d4c"
  head "https://github.com/herumi/ate-pairing.git"

  bottle do
    cellar :any
    sha256 "ad541d7df1098a90e8adb0a7073b5389959981a200a47866af07d6c000484378" => :yosemite
    sha256 "f6bc288cf0726b9364264cc973cb0307105d8f3e6bbd3c1df5c3d617d9e52049" => :mavericks
    sha256 "922f1755e308635d75f7e3903a5191db5074a46da82bf51ecd533367f435b455" => :mountain_lion
  end

  depends_on "xbyak"

  def install
    system "make", "-C", "src"
    lib.install "lib/libzm.a"
    (include+"ate-pairing").install Dir["include/*.h"]
  end

  test do
    (testpath / "test.cpp").write <<-EOS.undent
      #include <ate-pairing/bn.h>
      using namespace bn;

      const struct Point {
        struct G2 {
          const char *aa;
          const char *ab;
          const char *ba;
          const char *bb;
        } g2;
        struct G1 {
          int a;
          int b;
        } g1;
      } pt = {
        {
          "12723517038133731887338407189719511622662176727675373276651903807414909099441",
          "4168783608814932154536427934509895782246573715297911553964171371032945126671",
          "13891744915211034074451795021214165905772212241412891944830863846330766296736",
          "7937318970632701341203597196594272556916396164729705624521405069090520231616",
        },
        {
          -1, 1
        }
      };

      int main()
      {
        Param::init();
        const Ec2 g2(
          Fp2(Fp(pt.g2.aa), Fp(pt.g2.ab)),
          Fp2(Fp(pt.g2.ba), Fp(pt.g2.bb))
        );
        const Ec1 g1(pt.g1.a, pt.g1.b);
        mie::Vuint a("123456789");
        mie::Vuint b("98765432");
        Ec1 g1a = g1 * a;
        Ec2 g2b = g2 * b;
        Fp12 e, eab;
        opt_atePairing(e, g2, g1);
        opt_atePairing(eab, g2b, g1a);
        assert(eab == power(e, a*b));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lzm", "-o", "test"
    system "./test"
  end
end
