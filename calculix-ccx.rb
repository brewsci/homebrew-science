class CalculixCcx < Formula
  desc "Three-Dimensional Finite Element Solver"
  homepage "http://www.calculix.de/"
  url "http://www.dhondt.de/ccx_2.9.src.tar.bz2"
  version "2.9"
  sha256 "755e173cfb712c83cefef22cfa43f06caf495e5dffbecf8df3d47f3cf6e6d44d"

  depends_on :fortran
  depends_on "arpack"
  depends_on "pkg-config" => :build

  resource "test" do
    url "http://www.dhondt.de/ccx_2.9.test.tar.bz2"
    version "2.9"
    sha256 "6a2d864c970189c8b350f28826e9d3b624e2b3c1bad9f7f0ed45ccb2343c12e3"
  end

  resource "doc" do
    url "http://www.dhondt.de/ccx_2.9.htm.tar.bz2"
    version "2.9"
    sha256 "2313229b854e2558524d521ff586df05947416f0ee31a6b15edc59334e65178d"
  end

  resource "spooles" do
    # The spooles library is not currently maintained and so would not make a
    # good brew candidate. Instead it will be static linked to ccx.
    url "http://www.netlib.org/linalg/spooles/spooles.2.2.tgz"
    sha256 "a84559a0e987a1e423055ef4fdf3035d55b65bbe4bf915efaa1a35bef7f8c5dd"
  end

  # Add <pthread.h> to Calculix.h
  # Read arpack link options from pkg-config
  # u_free must return a void pointer
  patch :DATA

  def install
    (buildpath/"spooles").install resource("spooles")

    # Patch spooles library
    inreplace "spooles/Make.inc", "/usr/lang-4.0/bin/cc", ENV.cc
    inreplace "spooles/Tree/src/makeGlobalLib", "drawTree.c", "tree.c"

    # Build serial spooles library
    system "make", "-C", "spooles", "lib"

    # Extend library with multi-threading (MT) subroutines
    system "make", "-C", "spooles/MT/src", "makeLib"

    # Build Calculix ccx
    args = [
      "CC=#{ENV.cc}",
      "FC=#{ENV.fc}",
      "CFLAGS=-O2 -I../../spooles -DARCH=Linux -DSPOOLES -DARPACK -DMATRIXSTORAGE -DUSE_MT=1",
      "FFLAGS=-O2 -fopenmp",
      "DIR=../../spooles",
    ]
    target = Pathname.new("ccx_2.9/src/ccx_2.9")
    system "make", "-C", target.dirname, target.basename, *args
    bin.install target

    (buildpath/"test").install resource("test")
    pkgshare.install Dir["test/ccx_2.9/test/*"]

    (buildpath/"doc").install resource("doc")
    doc.install Dir["doc/ccx_2.9/doc/ccx/*"]
  end

  test do
    cp "#{pkgshare}/spring1.inp", testpath
    system "ccx_2.9", "spring1"
  end
end

__END__
diff --git a/ccx_2.9/src/CalculiX.h b/ccx_2.9/src/CalculiX.h
index fc1d1a5..7dcc1de 100755
--- a/ccx_2.9/src/CalculiX.h
+++ b/ccx_2.9/src/CalculiX.h
@@ -15,6 +15,7 @@
 /*     along with this program; if not, write to the Free Software       */
 /*     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.         */

+#include <pthread.h>
 #define Linux 1
 #define IRIX 2
 #define IRIX64 3
diff --git a/ccx_2.9/src/Makefile b/ccx_2.9/src/Makefile
index a76759b..4363d45 100755
--- a/ccx_2.9/src/Makefile
+++ b/ccx_2.9/src/Makefile
@@ -23,11 +23,12 @@ DIR=../../../SPOOLES.2.2

 LIBS = \
        $(DIR)/spooles.a \
-	../../../ARPACK/libarpack_INTEL.a \
-       -lpthread -lm -lc
+       $(shell pkg-config --libs arpack)

-ccx_2.9: $(OCCXMAIN) ccx_2.9.a  $(LIBS)
-	./date.pl; $(CC) $(CFLAGS) -c ccx_2.9.c; $(FC) -fopenmp -Wall -O3 -o $@ $(OCCXMAIN) ccx_2.9.a $(LIBS)
+ccx_2.9: $(OCCXMAIN) ccx_2.9.a
+	./date.pl
+	$(CC) $(CFLAGS) -c ccx_2.9.c
+	$(FC) $(FFLAGS) -o $@ $(OCCXMAIN) ccx_2.9.a $(LIBS)

 ccx_2.9.a: $(OCCXF) $(OCCXC)
	ar vr $@ $?
diff --git a/ccx_2.9/src/u_free.c b/ccx_2.9/src/u_free.c
index acccf3b..da517de 100644
--- a/ccx_2.9/src/u_free.c
+++ b/ccx_2.9/src/u_free.c
@@ -41,5 +41,5 @@ void *u_free(void* ptr,const char *file,const int line, const char* ptr_name){
   if(log_realloc==1) {
       printf("FREEING of variable %s, file %s, line=%d: oldaddress= %ld\n",ptr_name,file,line,(long int)ptr);
   }
-  return;
+  return NULL;
 }
