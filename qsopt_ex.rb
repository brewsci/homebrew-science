class QsoptEx < Formula
  desc "exact rational solution to LP instances having rational input"
  homepage "http://www.math.uwaterloo.ca/~bico/qsopt/ex/"
  url "http://www.math.uwaterloo.ca/~bico/qsopt/ex/QSex090408.tgz"
  version "2.5"
  sha256 "5949c65a8528fc170371d6f99461280f79313da91b1bc6d71d792c51601fa6bb"

  # Patch to fix a name change in a global variable of the GMP library
  patch :DATA

  depends_on "gmp"

  def install
    system "make"
    system "make", "-C", "demo"
    pkgshare.install "demo"
    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
    bin.install Dir["*solver"]
  end

  test do
    cp_r "#{pkgshare}/demo/.", testpath
    system "./demo_qs"
  end
end
__END__
diff --git a/EG/eg_lpnum.c b/EG/eg_lpnum.c
index d8e1dd1..603c293 100644
--- a/EG/eg_lpnum.c
+++ b/EG/eg_lpnum.c
@@ -143,7 +143,7 @@ void mpq_EGlpNumSet_mpf (mpq_t var,
	mpz_init_set_ui (max_den, (unsigned long int)1);
	mpz_mul_2exp (max_den, max_den, EGLPNUM_PRECISION >> 1);
	/* first we compute the exponent stored in the limbs */
-	__lexp = __cvl->_mp_exp * __GMP_BITS_PER_MP_LIMB;
+	__lexp = __cvl->_mp_exp * GMP_LIMB_BITS;
	if (__lexp < 0)
	{
		uexp = -__lexp;
