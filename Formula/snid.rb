class Snid < Formula
  desc "Determine redshifts, type, and age of Type Ia supernovae"
  homepage "https://people.lam.fr/blondin.stephane/software/snid"
  url "https://people.lam.fr/blondin.stephane/software/snid/snid-5.0.tar.gz"
  sha256 "22199803971fdd1bb394a550e81da661bd315224827373aae67408166873ec5c"
  revision 5

  bottle do
    sha256 "bc293aec48202ceee8a75a9b833251c0fbd7664ef749d5e732e452c2f0c95905" => :sierra
    sha256 "92d0fe0aebc1635bba087ba2b11afbc0bc0cb75ee97c33134009432fcda04c91" => :el_capitan
    sha256 "f97167fc4bc13827338ef498d44655c8b96c01c1a65186086d4bcbabadc0d169" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :x11
  depends_on :fortran
  depends_on "pgplot"

  resource "templates" do
    url "https://people.lam.fr/blondin.stephane/software/snid/templates-2.0.tgz"
    sha256 "c4bbe8795bd48dc21d707bfcb84e09ca5dca84034e54659523478a61571663db"
  end

  resource "bsnip_templates" do
    url "http://heracles.astro.berkeley.edu/sndb/static/BSNIPI/bsnip_v7_snid_templates.tar.gz"
    sha256 "e3db3a08667c9adc4ab826b2a10f0d2a48010b81cb9418875df5f23c0cba9605"
    version "7"
  end

  resource "button" do
    url "https://github.com/nicocardiel/button.git",
        :revision => "208b91c9f20775583128b856d5a53dcff0aa610a"
  end

  # no libbutton compilation and patch for new templates
  # as per https://people.lam.fr/blondin.stephane/software/snid/README_templates-2.0
  patch :DATA

  def install
    resource("button").stage do
      system "autoreconf", "-fvi"
      system "./configure"
      system "make", "-C", "src", "libbutton.la"
      (buildpath/"vendor/button/lib").install "src/.libs/libbutton.a"
    end

    # new templates
    resource("templates").stage { prefix.install "../templates-2.0" }

    # BSNIP
    resource("bsnip_templates").stage do
      safe_system "ls *.lnw > templist"
      cp "#{buildpath}/templates/texplist", "."
      cp "#{buildpath}/templates/tfirstlist", "."
      (prefix + "templates_bsnip_v7.0").install Dir["*"]
    end

    cp "source/snid.inc", "."
    # where to store spectral templates
    inreplace "source/snidmore.f", "INSTALL_DIR/snid-5.0/templates", "#{prefix}/templates-2.0"

    ENV.append "FCFLAGS", "-O -fno-automatic"
    ENV["PGLIBS"] = "-Wl,-framework -Wl,Foundation -L#{Formula["pgplot"].opt_lib} -lpgplot"
    system "make", "BUTTLIB=-L#{buildpath}/vendor/button/lib -lbutton"
    bin.install "snid", "logwave", "plotlnw"
    prefix.install "templates", "test"
    doc.install Dir["doc/*"]
  end

  test do
    system "#{bin}/snid", "inter=0", "plot=0", "#{prefix}/test/sn2003jo.dat"
    assert File.exist?("sn2003jo_snid.output")
    assert File.exist?("snid.param")
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -167,12 +167,11 @@ OUTILS2= utils/lnb.o utils/median.o
 OUTILS3= utils/four2.o utils/lnb.o
 
 # Button library
-BUTTLIB= button/libbutton.a
+BUTTLIB= -lbutton
 
 all : snid logwave plotlnw
 
 snid :  $(OBJ1) $(OUTILS1)
-	cd button && $(MAKE) FC=$(FC)
 	$(FC) $(FFLAGS) $(OBJ1) $(OUTILS1) $(XLIBS) $(BUTTLIB) $(PGLIBS) -o $@
 
 logwave : $(OBJ2) $(OUTILS2)
--- a/source/typeinfo.f
+++ b/source/typeinfo.f
@@ -48,6 +48,8 @@
       typename(1,4) = 'Ia-91bg'
       typename(1,5) = 'Ia-csm'
       typename(1,6) = 'Ia-pec'
+      typename(1,7) = 'Ia-99aa'
+      typename(1,8) = 'Ia-02cx'
 * SN Ib      
       typename(2,1) = 'Ib'
       typename(2,2) = 'Ib-norm'
@@ -70,6 +72,8 @@
       typename(5,3) = 'Gal'
       typename(5,4) = 'LBV'
       typename(5,5) = 'M-star'
+      typename(5,6) = 'C-star'
+      typename(5,7) = 'QSO'
 
       return
       end
--- a/source/snid.inc
+++ b/source/snid.inc
@@ -44,16 +44,16 @@
       parameter (MAXPARAM = 200)
       parameter (MAXPEAK = 20)
       parameter (MAXPLOT = 20)
-      parameter (MAXPPT = 20000)
+      parameter (MAXPPT = 50000)
       parameter (MAXR = 999.9)
       parameter (MAXRLAP = 999)
       parameter (MAXSN = 300)
       parameter (MAXUSE = 30)
-      parameter (MAXTEMP = 3000)
+      parameter (MAXTEMP = 10000)
       parameter (MAXTOK = 32)
       parameter (MAXWAVE = 10000)
       parameter (NT = 5)
-      parameter (NST = 6)
+      parameter (NST = 8)
 
       character*10 typename(NT,NST) ! character array containing type/subtype names
 
