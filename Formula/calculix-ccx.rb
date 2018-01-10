class CalculixCcx < Formula
  desc "Three-Dimensional Finite Element Solver"
  homepage "http://www.calculix.de/"
  url "http://www.dhondt.de/ccx_2.13.src.tar.bz2"
  version "2.13"
  sha256 "7685f4ddd0dc698fa1ad0f82594a6fe52ffa8f604c1e74befa048d3d46f49ce2"

  bottle do
    cellar :any
    sha256 "fdeb7b65ae2970e878b61e80e81074e36a89e7489e9fe39816279531068d3099" => :high_sierra
    sha256 "4c2595b652eb8b17e5875b7cfc57ae05c1f5dcf3dd94e350d9fa6a8c1ce2a260" => :sierra
    sha256 "4f18ebce2ac2c8fd9780cc0e3493f34159f59032a12ef34fc26343d5aacdc405" => :el_capitan
    sha256 "06699205b29b97ebc10c1f5385d0148b59ad745057578b2ba06b2ea9812ee6a0" => :x86_64_linux
  end

  option "with-openmp", "build with OpenMP support"
  needs :openmp if build.with? "openmp"

  depends_on :fortran
  depends_on "arpack"
  depends_on "pkg-config" => :build

  resource "test" do
    url "http://www.dhondt.de/ccx_2.13.test.tar.bz2"
    version "2.13"
    sha256 "b6eedf6797b5ac6550b21c48f9a13cbd6094eb335c72f587992a2f770af27ad0"
  end

  resource "doc" do
    url "http://www.dhondt.de/ccx_2.13.htm.tar.bz2"
    version "2.13"
    sha256 "34061658590d9c584c52037cfe3cb6d4305287092cce693a3776423459851b8b"
  end

  resource "spooles" do
    # The spooles library is not currently maintained and so would not make a
    # good brew candidate. Instead it will be static linked to ccx.
    url "http://www.netlib.org/linalg/spooles/spooles.2.2.tgz"
    sha256 "a84559a0e987a1e423055ef4fdf3035d55b65bbe4bf915efaa1a35bef7f8c5dd"
  end

  # Add <pthread.h> to Calculix.h
  # u_free must return a void pointer
  patch :DATA

  def install
    (buildpath/"spooles").install resource("spooles")

    # Patch spooles library
    inreplace "spooles/Make.inc", "/usr/lang-4.0/bin/cc", ENV.cc
    inreplace "spooles/Tree/src/makeGlobalLib", "drawTree.c", "tree.c"
    inreplace "ccx_2.13/src/Makefile", "-fopenmp", "" if build.without? "openmp"

    # Build serial spooles library
    system "make", "-C", "spooles", "lib"

    # Extend library with multi-threading (MT) subroutines
    system "make", "-C", "spooles/MT/src", "makeLib"

    # Buid Calculix ccx
    fflags= %w[-O2]
    fflags << "-fopenmp" if build.with? "openmp"
    cflags = %w[-O2 -I../../spooles -DARCH=Linux -DSPOOLES -DARPACK -DMATRIXSTORAGE]
    cflags << "-DUSE_MT=1" if build.with? "openmp"
    libs = ["$(DIR)/spooles.a", "$(shell pkg-config --libs arpack)"]
    # ARPACK uses Accelerate on macOS and OpenBLAS on Linux
    libs << "-framework accelerate" if OS.mac?
    libs << "-lopenblas -pthread" if OS.linux? # OpenBLAS uses pthreads
    args = ["CC=#{ENV.cc}",
            "FC=#{ENV.fc}",
            "CFLAGS=#{cflags.join(" ")}",
            "FFLAGS=#{fflags.join(" ")}",
            "DIR=../../spooles",
            "LIBS=#{libs.join(" ")}"]
    target = Pathname.new("ccx_2.13/src/ccx_2.13")
    system "make", "-C", target.dirname, target.basename, *args
    bin.install target

    (buildpath/"test").install resource("test")
    pkgshare.install Dir["test/ccx_2.13/test/*"]

    (buildpath/"doc").install resource("doc")
    doc.install Dir["doc/ccx_2.13/doc/ccx/*"]
  end

  test do
    cp "#{pkgshare}/spring1.inp", testpath
    system "#{bin}/ccx_2.13", "spring1"
  end
end

__END__
diff --git a/ccx_2.13/src/CalculiX.h b/ccx_2.13/src/CalculiX.h
index ee81ca8..d957130 100644
--- a/ccx_2.13/src/CalculiX.h
+++ b/ccx_2.13/src/CalculiX.h
@@ -15,6 +15,7 @@
 /*     along with this program; if not, write to the Free Software       */
 /*     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.         */

+#include <pthread.h>
 #define Linux 1
 #define IRIX 2
 #define IRIX64 3
diff --git a/ccx_2.13/src/Makefile b/ccx_2.13/src/Makefile
index 9335028..d7791f1 100755
--- a/ccx_2.13/src/Makefile
+++ b/ccx_2.13/src/Makefile
@@ -25,7 +25,7 @@ LIBS = \
	../../../ARPACK/libarpack_INTEL.a \
        -lpthread -lm -lc

-ccx_2.13: $(OCCXMAIN) ccx_2.13.a  $(LIBS)
+ccx_2.13: $(OCCXMAIN) ccx_2.13.a
	./date.pl; $(CC) $(CFLAGS) -c ccx_2.13.c; $(FC) -fopenmp -Wall -O3 -o $@ $(OCCXMAIN) ccx_2.13.a $(LIBS)

 ccx_2.13.a: $(OCCXF) $(OCCXC)
diff --git a/ccx_2.13/src/u_free.c b/ccx_2.13/src/u_free.c
index acccf3b..da517de 100644
--- a/ccx_2.13/src/u_free.c
+++ b/ccx_2.13/src/u_free.c
@@ -41,5 +41,5 @@ void *u_free(void* ptr,const char *file,const int line, const char* ptr_name){
   if(log_realloc==1) {
       printf("FREEING of variable %s, file %s, line=%d: oldaddress= %ld\n",ptr_name,file,line,(long int)ptr);
   }      
-  return;
+  return NULL;
 }
