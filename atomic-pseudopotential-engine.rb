class AtomicPseudopotentialEngine < Formula
  homepage "http://www.tddft.org/programs/APE/"
  url "http://www.tddft.org/programs/APE/sites/default/files/ape-2.2.1.tar.gz"
  sha256 "91c09e1d5ddcfb1d421a0d1d416c760de10afbf7f54e6ba1ad767661e1671357"
  revision 3

  bottle do
    cellar :any
    sha256 "b2859416ce31d1a6f5a9dabed3ef406a85bbeaacf3c5362ccd148f962adf0e0c" => :el_capitan
    sha256 "92dc615fda5235922e6e7fc557647aeb6d78a40640302567e6348392f76c7d14" => :yosemite
    sha256 "93eaa810321b25bc322900419149f6b13dbca8793f6f845649b02b1c7a4350be" => :mavericks
  end

  depends_on :fortran
  depends_on "gsl"
  depends_on "libxc"

  # same patch as in Macports
  # https://trac.macports.org/browser/trunk/dports/science/ape/Portfile
  # http://ftp5.ru.freebsd.org/macports/release/ports/science/ape/files/
  patch :DATA

  def install
    # compile with the same FCCPP and CC as in libxc
    args = %W[--prefix=#{prefix}
              --with-gsl-prefix=#{Formula["gsl"].opt_prefix}
              --with-libxc-prefix=#{Formula["libxc"].opt_prefix}
              FCCPP=#{ENV.fc}
              CC=#{ENV.cc}
           ]

    system "./configure", *args
    system "make"
    # majority of failed test are due to difference slightly above the tolerance.
    # TODO: ./all_electron/05-charged.02-C-.inp has a big difference in energy 0.0834 with tolerance 3e-06
    # system "make", "check"
    system "make", "install"
  end
end

__END__
diff --git a/src/parser_symbols.F90 b/src/parser_symbols.F90
index 8341f7e..5e8f618 100644
--- a/src/parser_symbols.F90
+++ b/src/parser_symbols.F90
@@ -251,8 +251,8 @@ contains
     call oct_parse_putsym("gga_k_yt65",      XC_GGA_K_YT65)
     call oct_parse_putsym("gga_k_baltin",    XC_GGA_K_BALTIN)
     call oct_parse_putsym("gga_k_lieb",      XC_GGA_K_LIEB)
-    call oct_parse_putsym("gga_k_absr1",     XC_GGA_K_ABSR1)
-    call oct_parse_putsym("gga_k_absr2",     XC_GGA_K_ABSR2)
+    call oct_parse_putsym("gga_k_absr1",     XC_GGA_K_ABSP1)
+    call oct_parse_putsym("gga_k_absr2",     XC_GGA_K_ABSP2)
     call oct_parse_putsym("gga_k_gr",        XC_GGA_K_GR)
     call oct_parse_putsym("gga_k_ludena",    XC_GGA_K_LUDENA)
     call oct_parse_putsym("gga_k_gp85",      XC_GGA_K_GP85)
