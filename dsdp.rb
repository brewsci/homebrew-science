class Dsdp < Formula
  desc "Software for Semidefinite Programming"
  homepage "http://www.mcs.anl.gov/hs/software/DSDP/"
  url "http://www.mcs.anl.gov/hs/software/DSDP/DSDP5.8.tar.gz"
  sha256 "26aa624525a636de272c0b329e2dfd01a0d5b7827f1c1c76f393d71e37dead70"

  bottle do
    cellar :any_skip_relocation
    sha256 "c647e5dd9882674846311d006d3055f947aa299959f77c57e4452e82f45ff811" => :el_capitan
    sha256 "8eb175be666a98748ba0853645500e9e2a3fda4e513a185524afbd438e61c266" => :yosemite
    sha256 "e13dbc58fb9629c4d18967991f95422ac6698db5000f2caa04d77d96f872480f" => :mavericks
  end

  def patches
    # let Homebrew choose compiler
    # choose LAPACK library between Accelerate.framework and OpenBLAS
    DATA
  end

  depends_on "openblas" => :optional

  def install
    if build.with? "openblas"
      lapacklib = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      lapacklib = "-framework Accelerate"
    end

    ENV["DSDPROOT"] = Dir.pwd
    system "make", "dsdpapi", "CC=" + ENV.cc, "LAPACKBLAS=" + lapacklib

    # bin contains just test files
    # bin.install Dir['bin/*']
    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
    # reuse official example for test
    pkgshare.install "examples/maxcut.c"
    pkgshare.install "bin/graph1"
  end

  test do
    if Tab.for_name("dsdp").with? "openblas"
      lapacklib = ["-L#{Formula["openblas"].opt_lib}", "-lopenblas"]
    else
      lapacklib = ["-framework", "Accelerate"]
    end
    system ENV.cc, "-o", "maxcut", "-I#{opt_include}", "#{opt_pkgshare}/maxcut.c", "-L#{opt_lib}", "-ldsdp", *lapacklib
    system "./maxcut", "#{opt_pkgshare}/graph1"
  end
end
__END__
diff --git a/make.include b/make.include
index d1b85f0..98d518a 100644
--- a/make.include
+++ b/make.include
@@ -6,7 +6,7 @@
 #   the defaults below should work, although fast BLAS and LAPACK recommended.

 # STEP 2: Set the name of the C compiler.
-CC       = gcc
+#CC       = gcc
 #CC       = cc
 #CC       = g++
 #CC       = mpicc
@@ -32,7 +32,7 @@ DSDPTIMER  = DSDP_TIME
 #DSDPTIMER  = DSDP_MS_TIME

 # STEP 3c: Add other compiler flags.
-DSDPCFLAGS =
+DSDPCFLAGS = -DDSDP_TIME
 #DSDPCFLAGS = -Wall
 #DSDPCFLAGS = -DDSDPMATLAB
 #  Other flags concern BLAS and LAPACK libraries -- see next step.
@@ -55,7 +55,7 @@ CLINKER	= ${CC} ${OPTFLAGS}
 # Not needed to compile library or matlab executable
 # Needed to link DSDP library to the driver ( read SDPA files, maxcut example, ...)
 # Also include the math library and other libraries needed to link the BLAS to the C files that call them.
-LAPACKBLAS  = -llapack -lblas -lg2c -lm
+#LAPACKBLAS  = -llapack -lblas -lg2c -lm
 #LAPACKBLAS  = -L/usr/lib/ -llapack -lblas -lg2c -lm
 #LAPACKBLAS  = -L/home/benson/ATLAS/Linux_P4SSE2/lib -llapack -lcblas -lf77blas -latlas -lg2c -lm
 #LAPACKBLAS  = -L/sandbox/benson/ATLAS-3.6/lib/Linux_P4SSE2  -llapack -lcblas -lf77blas -latlas -lg2c -lm
diff --git a/src/sys/dsdploginfo.c b/src/sys/dsdploginfo.c
index 9313549..cee4f93 100644
--- a/src/sys/dsdploginfo.c
+++ b/src/sys/dsdploginfo.c
@@ -6,7 +6,6 @@
 #include <stdarg.h>
 #include <sys/types.h>
 #include <stdlib.h>
-#include <malloc.h>
 #include "dsdpsys.h"
 #include "dsdpbasictypes.h"
