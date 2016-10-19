class Fplll < Formula
  desc "fplll: Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  # tag "math"
  url "https://github.com/fplll/fplll/releases/download/5.0.3/fplll-5.0.3.tar.gz"
  sha256 "d2b11b7dcb26c30ac1aab9ff75aca9b3dd6e0b0b40c382af16017a717dfe05c2"

  bottle do
    sha256 "a04abe726103e053f0f79ccc272dfe2d9d8889d5fd5994156d9407c42f19f303" => :sierra
    sha256 "28c720c3ddecc1fa1c81cb06e93a2afb2ccd831fa59cf97b41f8fa6eb10a6d5d" => :el_capitan
    sha256 "d2812782c33ac299a0989afe88e617d39a1b3b26339a0e0f94a1dfc88b9bec58" => :yosemite
  end

  needs :cxx11

  option "without-test", "Disable build-time checking (not recommended)"

  depends_on "gmp"
  depends_on "mpfr"

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--with-mpfr=#{Formula["mpfr"].opt_prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    ENV.cxx11
    (testpath/"test.cpp").write <<-EOS.undent
      // inspired from ./tests/test_lll.cpp
      #include <fplll.h>

      int main()
      {
        fplll::ZZ_mat<mpz_t> A;
        A.resize(50, 50 + 1); // construct 50 × (50+1) integer relations matrix
        A.gen_intrel(1000);   // generate 1000-bit coefficients
        return fplll::lll_reduction(A, LLL_DEF_DELTA, LLL_DEF_ETA, LM_PROVED, FT_MPFR, 0, LLL_DEFAULT);
      }
    EOS
    cxx_with_flags = ENV.cxx.split + ["test.cpp", "-lgmp", "-lmpfr", "-lfplll", "-o", "test"]
    system *cxx_with_flags
    system "./test"
  end
end
