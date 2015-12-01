class Propack < Formula
  homepage "http://soi.stanford.edu/~rmunk/PROPACK"
  url "http://soi.stanford.edu/~rmunk/PROPACK/PROPACK77_v2.1.tar.gz"
  sha256 "8ff42d1392cc31b19f2fda6d3ef436dd98c10daaede51cf9023e41dd2c478389"

  bottle do
    sha256 "c22dd4d0bb7402b7c7c544125713b020faac53777786e1637dbd56d259afc888" => :yosemite
    sha256 "999228f494d55c6b975df6fe88a0d884bf78a00754289187c1895cca5255f6bb" => :mavericks
    sha256 "ef4be83b9afb832151df6933cbff1fada192f30bd3e012b190eb85262a39f1cf" => :mountain_lion
  end

  option "without-check", "Disable build-time tests (not recommended)"

  depends_on "openblas" => :optional
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?
  depends_on :fortran

  # ETIME cannot be declared EXTERNAL with gfortran.
  patch :DATA

  def install
    openmp = (ENV.compiler == :clang) ? "" : "-fopenmp"
    if build.with? "openblas"
      blaslib = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      blaslib = "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    else
      blaslib = "-lblas -llapack"
    end
    if OS.mac?
      makeso = "libtool -dynamic -undefined dynamic_lookup -install_name #{lib}/$(notdir $@) -macosx_version_min 10.8 -o"
    else
      makeso = "$(F77) -shared -Wl,-soname -Wl,$(notdir $@) -o"
    end

    inreplace "make.inc" do |s|
      s.change_make_var! "PLAT", ((OS.mac?) ? "osx" : "linux")
      s.change_make_var! "F77", ENV["FC"]
      s.change_make_var! "FFLAGS", "-O3 -fPIC #{ENV["FFLAGS"]} #{openmp}"
      s.change_make_var! "FFLAGS_NOOPT", "-O0 -fPIC #{ENV["FFLAGS"]} #{openmp}"
      s.change_make_var! "FFLAGS_ACCURATE", "$(FFLAGS)"
      s.change_make_var! "CC", ENV["CC"]
      s.change_make_var! "CFLAGS", "-O3 -fPIC #{openmp}"
      s.change_make_var! "LINKER", "#{ENV["FC"]} #{openmp}"
      s.change_make_var! "MAKELIB", makeso
      s.change_make_var! "LINKFLAGS", "-O3"
      s.change_make_var! "BLAS", blaslib
      s.change_make_var! "RANLIB", "true"
      s.change_make_var! "MGS", "mgs.risc"
    end

    ENV.deparallelize

    system "make"

    # Install libs before 'make check' because of their install name.
    if OS.mac?
      lib.install Dir["single/*.dylib"] + Dir["double/*.dylib"] + Dir["complex8/*.dylib"] + Dir["complex16/*.dylib"]
    else
      libexec.install Dir["single/*.dylib"] + Dir["double/*.dylib"] + Dir["complex8/*.dylib"] + Dir["complex16/*.dylib"]
      Dir[libexec / "*.dylib"].each do |l|
        libname = File.basename(l, ".dylib")
        ln_sf l, lib / "#{libname}.so"
      end
    end

    if build.with? "check"
      system "make", "test"
      system "make", "verify"
    end

    (share / "propack/single").install Dir["single/Examples/*[^\.o]"]
    (share / "propack/double").install Dir["double/Examples/*[^\.o]"]
    (share / "propack/complex8").install Dir["complex8/Examples/*[^\.o]"]
    (share / "propack/complex16").install Dir["complex16/Examples/*[^\.o]"]
    prefix.install "make.inc"
  end
end

__END__
diff --git a/complex16/Examples/Makefile b/complex16/Examples/Makefile
index 900f2b6..d343e78 100644
--- a/complex16/Examples/Makefile
+++ b/complex16/Examples/Makefile
@@ -45,15 +45,15 @@ compare.$(PLAT).x: lib compare.o

 test:
	@( echo "==Testing DOUBLE COMPLEX version without implicit restart.=="; \
-	example.$(PLAT).x <  example.in; \
+	./example.$(PLAT).x <  example.in; \
	echo "==Testing DOUBLE COMPLEX version with implicit restart.=="; \
-	example_irl.$(PLAT).x <  example_irl.in )
+	./example_irl.$(PLAT).x <  example_irl.in )

 verify:
	@( echo "==Comparing DOUBLE COMPLEX results to reference.=="; \
-	compare.$(PLAT).x < compare.in; \
+	./compare.$(PLAT).x < compare.in; \
	echo "==Comparing DOUBLE COMPLEX IRL results to reference.=="; \
-	compare.$(PLAT).x < compare_irl.in )
+	./compare.$(PLAT).x < compare_irl.in )

 clean:
	rm -f  *.o *.il
diff --git a/complex16/second.F b/complex16/second.F
index 77fb342..cf0acbd 100644
--- a/complex16/second.F
+++ b/complex16/second.F
@@ -23,10 +23,10 @@

 #ifdef _AIX
       REAL               ETIME_
-      EXTERNAL           ETIME_
+C     EXTERNAL           ETIME_
 #else
       REAL               ETIME
-      EXTERNAL           ETIME
+C     EXTERNAL           ETIME
 #endif

 *     ..
diff --git a/complex8/Examples/Makefile b/complex8/Examples/Makefile
index 597c36d..23ec8e6 100644
--- a/complex8/Examples/Makefile
+++ b/complex8/Examples/Makefile
@@ -45,15 +45,15 @@ compare.$(PLAT).x: lib compare.o

 test:
	@( echo "==Testing COMPLEX version without implicit restart.=="; \
-	example.$(PLAT).x <  example.in; \
+	./example.$(PLAT).x <  example.in; \
	echo "==Testing COMPLEX version with implicit restart.=="; \
-	example_irl.$(PLAT).x <  example_irl.in )
+	./example_irl.$(PLAT).x <  example_irl.in )

 verify:
	@( echo "==Comparing COMPLEX results to reference.=="; \
-	compare.$(PLAT).x < compare.in; \
+	./compare.$(PLAT).x < compare.in; \
	echo "==Comparing COMPLEX IRL results to reference.=="; \
-	compare.$(PLAT).x < compare_irl.in )
+	./compare.$(PLAT).x < compare_irl.in )

 clean:
	rm -f  *.o *.il
diff --git a/complex8/second.F b/complex8/second.F
index 77fb342..cf0acbd 100644
--- a/complex8/second.F
+++ b/complex8/second.F
@@ -23,10 +23,10 @@

 #ifdef _AIX
       REAL               ETIME_
-      EXTERNAL           ETIME_
+C     EXTERNAL           ETIME_
 #else
       REAL               ETIME
-      EXTERNAL           ETIME
+C     EXTERNAL           ETIME
 #endif

 *     ..
diff --git a/double/Examples/Makefile b/double/Examples/Makefile
index 264fede..e7a19b6 100644
--- a/double/Examples/Makefile
+++ b/double/Examples/Makefile
@@ -45,15 +45,15 @@ compare.$(PLAT).x:  compare.o

 test:
	@( echo "==Testing DOUBLE PRECISION version without implicit restart.=="; \
-	example.$(PLAT).x <  example.in; \
+	./example.$(PLAT).x <  example.in; \
	echo "==Testing DOUBLE PRECISION version with implicit restart.=="; \
-	example_irl.$(PLAT).x <  example_irl.in )
+	./example_irl.$(PLAT).x <  example_irl.in )

 verify:
	@( echo "==Comparing DOUBLE PRECISION results to reference.=="; \
-	compare.$(PLAT).x < compare.in; \
+	./compare.$(PLAT).x < compare.in; \
	echo "==Comparing DOUBLE PRECISION IRL results to reference.=="; \
-	compare.$(PLAT).x < compare_irl.in )
+	./compare.$(PLAT).x < compare_irl.in )

 clean:
	rm -f  *.o *.il
diff --git a/double/second.F b/double/second.F
index 77fb342..cf0acbd 100644
--- a/double/second.F
+++ b/double/second.F
@@ -23,10 +23,10 @@

 #ifdef _AIX
       REAL               ETIME_
-      EXTERNAL           ETIME_
+C     EXTERNAL           ETIME_
 #else
       REAL               ETIME
-      EXTERNAL           ETIME
+C     EXTERNAL           ETIME
 #endif

 *     ..
diff --git a/single/Examples/Makefile b/single/Examples/Makefile
index 673ffb1..cb06b3b 100644
--- a/single/Examples/Makefile
+++ b/single/Examples/Makefile
@@ -46,15 +46,15 @@ compare.$(PLAT).x: lib compare.o

 test:
	@( echo "==Testing REAL version without implicit restart.=="; \
-	example.$(PLAT).x <  example.in; \
+	./example.$(PLAT).x <  example.in; \
	echo "==Testing REAL version with implicit restart.=="; \
-	example_irl.$(PLAT).x <  example_irl.in)
+	./example_irl.$(PLAT).x <  example_irl.in)

 verify:
	@( echo "==Comparing REAL results to reference.=="; \
-	compare.$(PLAT).x < compare.in; \
+	./compare.$(PLAT).x < compare.in; \
	echo "==Comparing REAL IRL results to reference.=="; \
-	compare.$(PLAT).x < compare_irl.in )
+	./compare.$(PLAT).x < compare_irl.in )

 clean:
	rm -f  *.o *.il
diff --git a/single/second.F b/single/second.F
index 77fb342..cf0acbd 100644
--- a/single/second.F
+++ b/single/second.F
@@ -23,10 +23,10 @@

 #ifdef _AIX
       REAL               ETIME_
-      EXTERNAL           ETIME_
+C     EXTERNAL           ETIME_
 #else
       REAL               ETIME
-      EXTERNAL           ETIME
+C     EXTERNAL           ETIME
 #endif

 *     ..
diff --git a/complex16/Lapack_Util/Makefile b/complex16/Lapack_Util/Makefile
index 8add156..e495915 100644
--- a/complex16/Lapack_Util/Makefile
+++ b/complex16/Lapack_Util/Makefile
@@ -29,12 +29,12 @@ dlasd4.o: dlasd4.f
	$(F77)	$(FFLAGS_ACCURATE) $(IPATH) -c -o $*.o $*.f


-lib: ../libzlapack_util_$(PLAT).a
+lib: ../libzlapack_util_$(PLAT).dylib

-../libzlapack_util_$(PLAT).a: $(OBJ)
-	$(MAKELIB) libzlapack_util_$(PLAT).a $(OBJ)
-	$(RANLIB)  libzlapack_util_$(PLAT).a
-	mv libzlapack_util_$(PLAT).a ..
+../libzlapack_util_$(PLAT).dylib: $(OBJ)
+	$(MAKELIB) libzlapack_util_$(PLAT).dylib $(OBJ)
+	$(RANLIB)  libzlapack_util_$(PLAT).dylib
+	mv libzlapack_util_$(PLAT).dylib ..

 clean:
	rm -f  *.o *.il
diff --git a/complex16/Makefile b/complex16/Makefile
index 6bd4b21..484ec29 100644
--- a/complex16/Makefile
+++ b/complex16/Makefile
@@ -20,12 +20,12 @@ DOBJ = zlanbpro.o zreorth.o zgetu0.o zsafescal.o dblasext.o zblasext.o \
	$(CC)  $(CFLAGS) $(IPATH) -c -o $*.o $*.c


-lib:  liblapack libzpropack_$(PLAT).a
+lib:  liblapack libzpropack_$(PLAT).dylib

-libzpropack_$(PLAT).a: $(DOBJ)
-	rm -f libzpropack_$(PLAT).a
-	$(MAKELIB) libzpropack_$(PLAT).a $(DOBJ)
-	$(RANLIB)  libzpropack_$(PLAT).a
+libzpropack_$(PLAT).dylib: $(DOBJ)
+	rm -f libzpropack_$(PLAT).dylib
+	$(MAKELIB) libzpropack_$(PLAT).dylib $(DOBJ)
+	$(RANLIB)  libzpropack_$(PLAT).dylib

 liblapack:
	@( cd Lapack_Util; \
diff --git a/complex8/Lapack_Util/Makefile b/complex8/Lapack_Util/Makefile
index 93522fc..b8280f1 100644
--- a/complex8/Lapack_Util/Makefile
+++ b/complex8/Lapack_Util/Makefile
@@ -30,12 +30,12 @@ slasd4.o: slasd4.f
	$(F77)	$(FFLAGS_ACCURATE) $(IPATH) -c -o $*.o $*.f


-lib: ../libclapack_util_$(PLAT).a
+lib: ../libclapack_util_$(PLAT).dylib

-../libclapack_util_$(PLAT).a: $(OBJ)
-	$(MAKELIB) libclapack_util_$(PLAT).a $(OBJ)
-	$(RANLIB)  libclapack_util_$(PLAT).a
-	cp libclapack_util_$(PLAT).a ..
+../libclapack_util_$(PLAT).dylib: $(OBJ)
+	$(MAKELIB) libclapack_util_$(PLAT).dylib $(OBJ)
+	$(RANLIB)  libclapack_util_$(PLAT).dylib
+	cp libclapack_util_$(PLAT).dylib ..

 clean:
	rm -f  *.o *.il
diff --git a/complex8/Makefile b/complex8/Makefile
index a636f06..fb760c6 100644
--- a/complex8/Makefile
+++ b/complex8/Makefile
@@ -20,12 +20,12 @@ DOBJ = clanbpro.o creorth.o cgetu0.o csafescal.o sblasext.o cblasext.o \
	$(CC)  $(CFLAGS) $(IPATH) -c -o $*.o $*.c


-lib: liblapack libcpropack_$(PLAT).a
+lib: liblapack libcpropack_$(PLAT).dylib

-libcpropack_$(PLAT).a : $(DOBJ)
-	rm -f libcpropack_$(PLAT).a
-	$(MAKELIB) libcpropack_$(PLAT).a $(DOBJ)
-	$(RANLIB)  libcpropack_$(PLAT).a
+libcpropack_$(PLAT).dylib : $(DOBJ)
+	rm -f libcpropack_$(PLAT).dylib
+	$(MAKELIB) libcpropack_$(PLAT).dylib $(DOBJ)
+	$(RANLIB)  libcpropack_$(PLAT).dylib

 liblapack:
	@( cd Lapack_Util; \
diff --git a/double/Lapack_Util/Makefile b/double/Lapack_Util/Makefile
index ecd5235..20f082c 100644
--- a/double/Lapack_Util/Makefile
+++ b/double/Lapack_Util/Makefile
@@ -30,12 +30,12 @@ dlasd4.o: dlasd4.f
	$(F77)	$(FFLAGS_ACCURATE) $(IPATH) -c -o $*.o $*.f


-lib: ../libdlapack_util_$(PLAT).a
+lib: ../libdlapack_util_$(PLAT).dylib

-../libdlapack_util_$(PLAT).a: $(OBJ)
-	$(MAKELIB) libdlapack_util_$(PLAT).a $(OBJ)
-	$(RANLIB)  libdlapack_util_$(PLAT).a
-	cp libdlapack_util_$(PLAT).a ..
+../libdlapack_util_$(PLAT).dylib: $(OBJ)
+	$(MAKELIB) libdlapack_util_$(PLAT).dylib $(OBJ)
+	$(RANLIB)  libdlapack_util_$(PLAT).dylib
+	cp libdlapack_util_$(PLAT).dylib ..

 clean:
	rm -f  *.o *.il
diff --git a/double/Makefile b/double/Makefile
index 7b257d0..874e8c7 100644
--- a/double/Makefile
+++ b/double/Makefile
@@ -20,13 +20,13 @@ DOBJ = dlanbpro.o dreorth.o dgetu0.o dsafescal.o dblasext.o \
	$(CC)  $(CFLAGS) $(IPATH) -c -o $*.o $*.c


-lib: liblapack libdpropack_$(PLAT).a
+lib: liblapack libdpropack_$(PLAT).dylib


-libdpropack_$(PLAT).a : $(DOBJ)
-	rm -f libdpropack_$(PLAT).a
-	$(MAKELIB) libdpropack_$(PLAT).a $(DOBJ)
-	$(RANLIB)  libdpropack_$(PLAT).a
+libdpropack_$(PLAT).dylib : $(DOBJ)
+	rm -f libdpropack_$(PLAT).dylib
+	$(MAKELIB) libdpropack_$(PLAT).dylib $(DOBJ)
+	$(RANLIB)  libdpropack_$(PLAT).dylib

 liblapack:
	@( cd Lapack_Util; \
diff --git a/single/Lapack_Util/Makefile b/single/Lapack_Util/Makefile
index 542aefc..e52d56d 100644
--- a/single/Lapack_Util/Makefile
+++ b/single/Lapack_Util/Makefile
@@ -29,12 +29,12 @@ slasd4.o: slasd4.f
	$(F77)	$(FFLAGS_ACCURATE) $(IPATH) -c -o $*.o $*.f


-lib: ../libslapack_util_$(PLAT).a
+lib: ../libslapack_util_$(PLAT).dylib

-../libslapack_util_$(PLAT).a: $(OBJ)
-	$(MAKELIB) libslapack_util_$(PLAT).a $(OBJ)
-	$(RANLIB)  libslapack_util_$(PLAT).a
-	mv libslapack_util_$(PLAT).a ..
+../libslapack_util_$(PLAT).dylib: $(OBJ)
+	$(MAKELIB) libslapack_util_$(PLAT).dylib $(OBJ)
+	$(RANLIB)  libslapack_util_$(PLAT).dylib
+	mv libslapack_util_$(PLAT).dylib ..

 clean:
	rm -f  *.o *.il
diff --git a/single/Makefile b/single/Makefile
index 6882c4e..b6ca71b 100644
--- a/single/Makefile
+++ b/single/Makefile
@@ -20,12 +20,12 @@ DOBJ = slanbpro.o sreorth.o sgetu0.o ssafescal.o sblasext.o \
	$(CC)  $(CFLAGS) $(IPATH) -c -o $*.o $*.c


-lib: liblapack libspropack_$(PLAT).a
+lib: liblapack libspropack_$(PLAT).dylib

-libspropack_$(PLAT).a: $(DOBJ)
-	rm -f libspropack_$(PLAT).a
-	$(MAKELIB) libspropack_$(PLAT).a $(DOBJ)
-	$(RANLIB)  libspropack_$(PLAT).a
+libspropack_$(PLAT).dylib: $(DOBJ)
+	rm -f libspropack_$(PLAT).dylib
+	$(MAKELIB) libspropack_$(PLAT).dylib $(DOBJ)
+	$(RANLIB)  libspropack_$(PLAT).dylib

 liblapack:
	@( cd Lapack_Util; \
diff --git a/complex16/Lapack_Util/Makefile b/complex16/Lapack_Util/Makefile
index e495915..89070e2 100644
--- a/complex16/Lapack_Util/Makefile
+++ b/complex16/Lapack_Util/Makefile
@@ -8,7 +8,7 @@ dbdsqr.o  dlanst.o  dlasd0.o  dlasd5.o  dlasdq.o  dlasq3.o  dlasrt.o  lsame.o \
 dlacpy.o  dlapy2.o  dlasd1.o  dlasd6.o  dlasdt.o  dlasq4.o  dlassq.o \
 dlaed6.o  dlartg.o  dlasd2.o  dlasd7.o  dlaset.o  dlasq5.o  dlasv2.o \
 dlas2.o   dlasd3.o  dlasd8.o  dlasq1.o  dlasq6.o  dlamch.o xerbla.o \
-ieeeck.o  dlartg.o  dlarnv.o  dlaruv.o  zlarnv.o  zlascl.o
+ieeeck.o  dlarnv.o  dlaruv.o  zlarnv.o  zlascl.o

 .F.o:
	$(F77) $(FFLAGS) $(IPATH) -c -o $*.o $*.F
diff --git a/complex8/Lapack_Util/Makefile b/complex8/Lapack_Util/Makefile
index b8280f1..525b1ef 100644
--- a/complex8/Lapack_Util/Makefile
+++ b/complex8/Lapack_Util/Makefile
@@ -8,7 +8,7 @@ OBJ = sbdsdc.o slamrg.o slascl.o slasd4.o slasda.o slasq2.o  slasr.o  \
  slacpy.o  slapy2.o  slasd1.o  slasd6.o  slasdt.o  slasq4.o  slassq.o \
  slaed6.o  slartg.o  slasd2.o  slasd7.o  slaset.o  slasq5.o  slasv2.o \
  slas2.o   slasd3.o  slasd8.o  slasq1.o  slasq6.o  ieeeck.o \
- slartg.o  slarnv.o  slaruv.o  clarnv.o \
+ slarnv.o  slaruv.o  clarnv.o \
  clascl.o  lsame.o   ilaenv.o   slamch.o xerbla.o

 .F.o:
diff --git a/double/Lapack_Util/Makefile b/double/Lapack_Util/Makefile
index 20f082c..a4904fa 100644
--- a/double/Lapack_Util/Makefile
+++ b/double/Lapack_Util/Makefile
@@ -8,7 +8,7 @@ dbdsqr.o  dlanst.o  dlasd0.o  dlasd5.o  dlasdq.o  dlasq3.o  dlasrt.o  lsame.o \
 dlacpy.o  dlapy2.o  dlasd1.o  dlasd6.o  dlasdt.o  dlasq4.o  dlassq.o \
 dlaed6.o  dlartg.o  dlasd2.o  dlasd7.o  dlaset.o  dlasq5.o  dlasv2.o \
 dlas2.o   dlasd3.o  dlasd8.o  dlasq1.o  dlasq6.o \
-ieeeck.o  dlartg.o  dlarnv.o  dlaruv.o    dlamch.o xerbla.o
+ieeeck.o  dlarnv.o  dlaruv.o    dlamch.o xerbla.o

 .F.o:
	$(F77) $(FFLAGS) $(IPATH) -c -o $*.o $*.F
diff --git a/single/Lapack_Util/Makefile b/single/Lapack_Util/Makefile
index e52d56d..6897472 100644
--- a/single/Lapack_Util/Makefile
+++ b/single/Lapack_Util/Makefile
@@ -8,7 +8,7 @@ ilaenv.o sbdsqr.o  slanst.o  slasd0.o  slasd5.o  slasdq.o  slasq3.o  slasrt.o \
 lsame.o  slacpy.o  slapy2.o  slasd1.o  slasd6.o  slasdt.o  slasq4.o  slassq.o \
 slaed6.o slartg.o  slasd2.o  slasd7.o  slaset.o  slasq5.o  slasv2.o \
 slas2.o  slasd3.o  slasd8.o  slasq1.o  slasq6.o  \
-ieeeck.o slartg.o  slarnv.o  slaruv.o  slamch.o xerbla.o
+ieeeck.o slarnv.o  slaruv.o  slamch.o xerbla.o

 .F.o:
	$(F77) $(FFLAGS) $(IPATH) -c -o $*.o $*.F
diff --git a/complex16/Examples/Makefile b/complex16/Examples/Makefile
index d343e78..f8ed388 100644
--- a/complex16/Examples/Makefile
+++ b/complex16/Examples/Makefile
@@ -4,7 +4,7 @@
 include ../../make.inc
 IPATH = -I..
 LPATH = $(LIBPATH) -L.. -L.
-LIBS = ../libzpropack_$(PLAT).a ../libzlapack_util_$(PLAT).a $(BLAS) ../libzlapack_util_$(PLAT).a
+LIBS = ../libzpropack_$(PLAT).dylib ../libzlapack_util_$(PLAT).dylib $(BLAS) ../libzlapack_util_$(PLAT).dylib
 #LIBS = -lzpropack_$(PLAT) -lmkl_lapack $(BLAS)


diff --git a/complex8/Examples/Makefile b/complex8/Examples/Makefile
index 23ec8e6..0045c7d 100644
--- a/complex8/Examples/Makefile
+++ b/complex8/Examples/Makefile
@@ -4,7 +4,7 @@
 include ../../make.inc
 IPATH = -I..
 LPATH = $(LIBPATH) -L.. -L.
-LIBS = ../libcpropack_$(PLAT).a ../libclapack_util_$(PLAT).a $(BLAS)  ../libclapack_util_$(PLAT).a
+LIBS = ../libcpropack_$(PLAT).dylib ../libclapack_util_$(PLAT).dylib $(BLAS)  ../libclapack_util_$(PLAT).dylib
 #LIBS = -lcpropack_$(PLAT) -lmkl_lapack $(BLAS)


diff --git a/double/Examples/Makefile b/double/Examples/Makefile
index e7a19b6..c09d611 100644
--- a/double/Examples/Makefile
+++ b/double/Examples/Makefile
@@ -4,7 +4,7 @@
 include ../../make.inc
 IPATH = -I..
 LPATH = $(LIBPATH) -L.. -L.
-LIBS = ../libdpropack_$(PLAT).a ../libdlapack_util_$(PLAT).a $(BLAS) ../libdlapack_util_$(PLAT).a
+LIBS = ../libdpropack_$(PLAT).dylib ../libdlapack_util_$(PLAT).dylib $(BLAS) ../libdlapack_util_$(PLAT).dylib
 #LIBS = -ldpropack_$(PLAT) -lmkl_lapack $(BLAS)


diff --git a/single/Examples/Makefile b/single/Examples/Makefile
index cb06b3b..9b7f72a 100644
--- a/single/Examples/Makefile
+++ b/single/Examples/Makefile
@@ -4,7 +4,7 @@
 include ../../make.inc
 IPATH = -I..
 LPATH = $(LIBPATH) -L.. -L.
-LIBS = ../libspropack_$(PLAT).a  ../libslapack_util_$(PLAT).a $(BLAS)  ../libslapack_util_$(PLAT).a
+LIBS = ../libspropack_$(PLAT).dylib  ../libslapack_util_$(PLAT).dylib $(BLAS)  ../libslapack_util_$(PLAT).dylib
 #LIBS = -lspropack_$(PLAT)  -lslapack_util_$(PLAT) $(BLAS)  -lslapack_util_$(PLAT)
 #LIBS = -lspropack_$(PLAT) -lmkl_lapack $(BLAS)
