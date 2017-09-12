class Fplll < Formula
  desc "Lattice algorithms using floating-point arithmetic"
  homepage "https://github.com/fplll/fplll"
  # tag "math"
  url "https://github.com/fplll/fplll/releases/download/5.2.0/fplll-5.2.0.tar.gz"
  sha256 "75e17fcaa4fc5fdddbe6eb42aca5f38c4c169a4b52756e74fbe2d1769737ac9c"

  bottle do
    sha256 "30e57a63f3f73b7c6c0bf2483b77302e7f850c764b4676f9aaca75b2a8be7e13" => :sierra
    sha256 "36ace8be9340aa6cf29ed1d431f56e0c8df9064005334d9ffae14aaf039ce7a3" => :el_capitan
    sha256 "46430c3ce03a664c7a14f22335bbfe99728a77f08e9447bca95ce5be66c42011" => :x86_64_linux
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
