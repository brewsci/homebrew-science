class Fplll < Formula
  desc "fplll: Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  # tag "math"
  url "https://github.com/fplll/fplll/releases/download/5.1.0/fplll-5.1.0.tar.gz"
  sha256 "58175c54cc92752576a64361c73e4ea7797fc18fb703b3f22c7570a09075486f"

  bottle do
    sha256 "4d5560046f79d850f084b07cfbc59e27a550c969259302f95ac078f5da7e5bff" => :sierra
    sha256 "6c3c1786af768c3709cd7d3fba22b9a4f0014e9c2fe77561f2bfe0f696f56cc8" => :el_capitan
    sha256 "6cc00e68dfff0ca011839e86d1d38a9d4e59a767ec953fe93e77546f44e5dc4d" => :yosemite
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
