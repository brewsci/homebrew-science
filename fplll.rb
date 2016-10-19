class Fplll < Formula
  desc "fplll: Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  # tag "math"
  url "https://github.com/fplll/fplll/releases/download/5.0.3/fplll-5.0.3.tar.gz"
  sha256 "d2b11b7dcb26c30ac1aab9ff75aca9b3dd6e0b0b40c382af16017a717dfe05c2"

  bottle do
    sha256 "491208e21633670637197906301caa4de673226f79121b4ea9b0d464b1ae0cd1" => :el_capitan
    sha256 "188ec3033d607103a242c0809062fe012e19aa06b07dab9a2a8c6ab17ce66506" => :yosemite
    sha256 "b494ba9cf9a01e4efc4db5e7c6c271c5d8e6153a972a40eb8f6ceafe9c5da94e" => :mavericks
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
