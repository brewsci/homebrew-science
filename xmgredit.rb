class Xmgredit < Formula
  desc "Motif-based editor for computation grids of models such as ADCIRC"
  homepage "http://www.stccmop.org/knowledge_transfer/software/selfe/ace_tools"
  url "http://www.stccmop.org/CORIE/modeling/selfe/ace.tgz"
  version "5.1"
  sha256 "442abbe1e81e3ea33f310a0a43020ef5165768c4b57cf5a97757bd87a758e9f1"
  revision 1

  bottle :disable, "needs to be rebuilt with latest netcdf"

  depends_on :x11
  depends_on "netcdf"
  depends_on "openmotif"
  depends_on "triangle"

  patch :DATA

  def install
    Dir.chdir "xmgredit5"
    bin.mkpath
    system "make", "install", "INSTALLDIR=#{prefix}"
  end
end
__END__
Patch to remove Triangle dependencies (as those are handled by the Triangle
formula), to enable NetCDF support and to sort out compiler flags.
diff -u b/Makefile b/Makefile
--- b/xmgredit5/Makefile
+++ b/xmgredit5/Makefile
@@ -10,20 +10,20 @@
 # Uncomment the following 3 defines for netCDF support
 # adjust paths to suit local conditions
 #
-#NETCDF = -DHAVE_NETCDF
-#NETCDFINCLUDES = -I/usr/local/ace/netcdf/include
-#NETCDFLIBS = -L/usr/local/ace/netcdf/lib -lnetcdf
+NETCDFFLAGS=-DHAVE_NETCDF
+NETCDFLIBS=-lnetcdf
+
+TRIANGLEFLAGS=-DDO_TRIANGLE
+TRIAGLELIBS=-ltriangle

 ############################################
 # LINUX
-LIBS = -L/usr/X11R6/lib64 -lXm -lXp -lXt -lXext -lXpm -lX11 -lICE -lSM -lm
-INCLUDES = -I/usr/X11R6/include
-CC = gcc -g
+LIBS=$(LDFLAGS) -lXm -lXp -lXt -lXext -lXpm -lX11 -lICE -lSM -lm $(NETCDFLIBS) $(TRIAGLELIBS)
+CFLAGS+=$(NETCDFFLAGS) $(TRIANGLEFLAGS)

 #################
 ####### End of configuration, no changes should be required below #########
 #################
-CFLAGS = -DDO_TRIANGLE $(INCLUDES)

 OBJS = main.o\
 	vers.o\
@@ -75,7 +75,6 @@
 	params.o\
 	malerts.o\
 	motifutils.o\
-	triangle.o\
 	tritest.o\
 	vedglist.o\
 	vgeometry.o\
@@ -140,7 +139,6 @@
 	params.c\
 	malerts.c\
 	motifutils.c\
-	triangle.c\
 	tritest.c\
 	vedglist.c\
 	vgeometry.c\
@@ -173,14 +172,13 @@
 	patterns.h\
 	special.h\
 	graphics.h\
-	triangle.h\
 	vdefines.h\
 	vdefs.h

-all: xmgredit5
+all: xmgredit

-xmgredit5: $(OBJS) $(PARSOBJS)
-	$(CC) $(OBJS) $(PARSOBJS) -o xmgredit5 $(LIBS)
+xmgredit: $(OBJS) $(PARSOBJS)
+	$(CC) $(OBJS) $(PARSOBJS) -o xmgredit $(LIBS)

 tx: tx.o
	$(CC) tx.o -o tx -L/usr/local/lib -lgd $(LIBS)
@@ -188,9 +185,6 @@
 $(OBJS): defines.h globals.h
 eventproc.c: defines.h globals.h

-triangle.o:
-	$(CC) -c -DTRILIBRARY triangle.c
-
 vers.o: $(SRCS) pars.y
	sh newvers.sh
	$(CC) -c vers.c
@@ -218,8 +212,8 @@
 	touch rcs
 	grep Id:  Makefile $(SRCS) $(INCS) $(PARSSRCS) > release.tmp

-install: xmgredit5
-	cp -p xmgredit5 $(INSTALLDIR)/bin/xmgredit5
+install: xmgredit
+	cp -p xmgredit $(INSTALLDIR)/bin/xmgredit

 lint:
 	lint  -axv -wk -Nn10000 -Nd10000 $(SRCS) $(PARSSRCS)
@@ -230,3 +224,3 @@
 clean:
-	/bin/rm *.o xmgredit5
+	/bin/rm *.o xmgredit
