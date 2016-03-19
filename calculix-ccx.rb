class CalculixCcx < Formula
  desc "Three-Dimensional Finite Element Solver"
  homepage "http://www.calculix.de/"
  url "http://www.dhondt.de/ccx_2.10.src.tar.bz2"
  version "2.10"
  sha256 "693497d19d8dd2a5376e64e038d5c248d87f0e2df46d409a83bf976596b319f5"

  bottle do
    cellar :any
    sha256 "14f29dd416a4d8ad14d55598b5d53d5bbb74681dec38bd6f1760c781b9a0671b" => :el_capitan
    sha256 "490e79f5f3ad45f456b58a4959436735cf4225ff5e2c56c54ee5ab932bccced5" => :yosemite
    sha256 "6ebcb57fd3af53068e3955a17b85fe9016bb6a03393bdb778fa280bbd24bca32" => :mavericks
  end

  depends_on :fortran
  depends_on "arpack"
  depends_on "pkg-config" => :build

  resource "test" do
    url "http://www.dhondt.de/ccx_2.10.test.tar.bz2"
    version "2.10"
    sha256 "a5e00abc7f9b2a5a5f1a4f7b414617dc65cd0be9b2a66c93e20b5a25c1392a75"
  end

  resource "doc" do
    url "http://www.dhondt.de/ccx_2.10.htm.tar.bz2"
    version "2.10"
    sha256 "28f09511d791016dadb9f9cce382789fc250dfa5a60b105cfc4c9c2008e437c2"
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
    target = Pathname.new("ccx_2.10/src/ccx_2.10")
    system "make", "-C", target.dirname, target.basename, *args
    bin.install target

    (buildpath/"test").install resource("test")
    pkgshare.install Dir["test/ccx_2.10/test/*"]

    (buildpath/"doc").install resource("doc")
    doc.install Dir["doc/ccx_2.10/doc/ccx/*"]
  end

  test do
    cp "#{pkgshare}/spring1.inp", testpath
    system "ccx_2.10", "spring1"
  end
end

__END__
diff --git a/ccx_2.10/src/CalculiX.h b/ccx_2.10/src/CalculiX.h
index ee81ca8..d957130 100644
--- a/ccx_2.10/src/CalculiX.h
+++ b/ccx_2.10/src/CalculiX.h
@@ -15,6 +15,7 @@
 /*     along with this program; if not, write to the Free Software       */
 /*     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.         */

+#include <pthread.h>
 #define Linux 1
 #define IRIX 2
 #define IRIX64 3
diff --git a/ccx_2.10/src/Makefile b/ccx_2.10/src/Makefile
index 9335028..a587fdd 100755
--- a/ccx_2.10/src/Makefile
+++ b/ccx_2.10/src/Makefile
@@ -22,11 +22,12 @@ DIR=../../../SPOOLES.2.2

 LIBS = \
        $(DIR)/spooles.a \
-	../../../ARPACK/libarpack_INTEL.a \
-       -lpthread -lm -lc
+       $(shell pkg-config --libs arpack)

-ccx_2.10: $(OCCXMAIN) ccx_2.10.a  $(LIBS)
-	./date.pl; $(CC) $(CFLAGS) -c ccx_2.10.c; $(FC) -fopenmp -Wall -O3 -o $@ $(OCCXMAIN) ccx_2.10.a $(LIBS)
+ccx_2.10: $(OCCXMAIN) ccx_2.10.a
+	./date.pl
+	$(CC) $(CFLAGS) -c ccx_2.10.c
+	$(FC) $(FFLAGS) -o $@ $(OCCXMAIN) ccx_2.10.a $(LIBS)

 ccx_2.10.a: $(OCCXF) $(OCCXC)
	ar vr $@ $?
diff --git a/ccx_2.10/src/u_free.c b/ccx_2.10/src/u_free.c
index acccf3b..da517de 100644
--- a/ccx_2.10/src/u_free.c
+++ b/ccx_2.10/src/u_free.c
@@ -41,5 +41,5 @@ void *u_free(void* ptr,const char *file,const int line, const char* ptr_name){
   if(log_realloc==1) {
       printf("FREEING of variable %s, file %s, line=%d: oldaddress= %ld\n",ptr_name,file,line,(long int)ptr);
   }
-  return;
+  return NULL;
 }
