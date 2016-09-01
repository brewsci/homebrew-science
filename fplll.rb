class Fplll < Formula
  desc "fplll: Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  # tag "math"
  url "https://github.com/fplll/fplll/releases/download/5.0.2/fplll-5.0.2.tar.gz"
  sha256 "b601d7917cbfda145644bc84bc11a4dee5dfe7f369b0ab62823f47a41d5a81e5"

  bottle do
    sha256 "deaac09f3e3f65082042123aa1280d7e5328252da3c3fdde3c6be6de82764d1e" => :el_capitan
    sha256 "c04639d7684321f0b9821c52fad2fdb95d51826d10b7b0b3871f658461e48115" => :yosemite
    sha256 "d94490c6e365cdfd7a1165a13bf90ec20d0f9af3114ee15766e0a9fa9ed37440" => :mavericks
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
