class QsoptEx < Formula
  desc "Exact rational solution to LP instances having rational input"
  homepage "https://www.math.uwaterloo.ca/~bico/qsopt/ex/"
  url "https://www.math.uwaterloo.ca/~bico/qsopt/ex/QSex090408.tgz"
  version "2.5"
  sha256 "5949c65a8528fc170371d6f99461280f79313da91b1bc6d71d792c51601fa6bb"

  bottle do
    cellar :any
    sha256 "4cdde0071a2ae2a737772f90060d9997fed15f869a43b7cab7ebee8da8578d0f" => :el_capitan
    sha256 "ba7975b0a1ce2b9502e6eac784855c74502aef70fb3f20ce8a6f344d2956e0b2" => :yosemite
    sha256 "95037868110bcd2a4482534cc1b59529c3c849e45305b3cf2f266f92cc6f97cc" => :mavericks
  end

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
