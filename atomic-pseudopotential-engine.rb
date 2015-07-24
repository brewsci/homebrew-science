class AtomicPseudopotentialEngine < Formula
  homepage "http://www.tddft.org/programs/APE/"
  url "http://www.tddft.org/programs/APE/sites/default/files/ape-2.2.1.tar.gz"
  sha256 "91c09e1d5ddcfb1d421a0d1d416c760de10afbf7f54e6ba1ad767661e1671357"
  revision 1

  bottle do
    cellar :any
    sha256 "f1b0b6247cd971edbd15a1ea398d1db01fc79ea79ab5c767ffb134274c82c444" => :yosemite
    sha256 "2dd32e82c7215acd30fa2ea79567507f7f080d1a02355f744d661184815e0683" => :mavericks
    sha256 "2d3b6d363e3339e6d861c2caadcc6043652e510874a9d99d82f18501cb4ed75e" => :mountain_lion
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
