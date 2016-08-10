class CalculixCcx < Formula
  desc "Three-Dimensional Finite Element Solver"
  homepage "http://www.calculix.de/"
  url "http://www.dhondt.de/ccx_2.11.src.tar.bz2"
  version "2.11"
  sha256 "11588c7a2836cadbc4c6f2b866b0daa67512eebe755887094a76a997e6dc2493"
  revision 1

  bottle do
    cellar :any
    sha256 "295f3dba9dddeb95f409800f4d56404aeb3a1157124fcb5d0b58277d5c94f5c4" => :el_capitan
    sha256 "f32e5da68f500d8eaeab9ef9d7f2e96aad7a5cfa9c83251cc1a526c197048325" => :yosemite
    sha256 "88dfee5dae610f5d34386d8ee0dc14f973520693eddf62f653febd15fc4ef1f1" => :mavericks
  end

  option "with-openmp", "build with OpenMP support"
  needs :openmp if build.with? "openmp"

  depends_on :fortran
  depends_on "arpack"
  depends_on "pkg-config" => :build

  resource "test" do
    url "http://www.dhondt.de/ccx_2.11.test.tar.bz2"
    version "2.11"
    sha256 "3bb676e689b83129aa7a24a1f87e59fec61b70e486c85ed590ef1baffc77db0a"
  end

  resource "doc" do
    url "http://www.dhondt.de/ccx_2.11.htm.tar.bz2"
    version "2.11"
    sha256 "8cd8beec5cb010d50a9b0013ffc80785f7a0393236d88a49b36de6795949bab1"
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
    inreplace "ccx_2.11/src/Makefile", "-fopenmp", "" if build.without? "openmp"

    # Build serial spooles library
    system "make", "-C", "spooles", "lib"

    # Extend library with multi-threading (MT) subroutines
    system "make", "-C", "spooles/MT/src", "makeLib"

    # Buid Calculix ccx
    fflags= %w[-O2]
    fflags << "-fopenmp" if build.with? "openmp"
    cflags = %w[-O2 -I../../spooles -DARCH=Linux -DSPOOLES -DARPACK -DMATRIXSTORAGE]
    cflags << "-DUSE_MT=1" if build.with? "openmp"
    args = ["CC=#{ENV.cc}",
            "FC=#{ENV.fc}",
            "CFLAGS=#{cflags.join(" ")}",
            "FFLAGS=#{fflags.join(" ")}",
            "DIR=../../spooles",
            "LIBS=$(DIR)/spooles.a $(shell pkg-config --libs arpack)"]
    target = Pathname.new("ccx_2.11/src/ccx_2.11")
    system "make", "-C", target.dirname, target.basename, *args
    bin.install target

    (buildpath/"test").install resource("test")
    pkgshare.install Dir["test/ccx_2.11/test/*"]

    (buildpath/"doc").install resource("doc")
    doc.install Dir["doc/ccx_2.11/doc/ccx/*"]
  end

  test do
    cp "#{pkgshare}/spring1.inp", testpath
    system "ccx_2.11", "spring1"
  end
end

__END__
diff --git a/ccx_2.11/src/CalculiX.h b/ccx_2.11/src/CalculiX.h
index ee81ca8..d957130 100644
--- a/ccx_2.11/src/CalculiX.h
+++ b/ccx_2.11/src/CalculiX.h
@@ -15,6 +15,7 @@
 /*     along with this program; if not, write to the Free Software       */
 /*     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.         */

+#include <pthread.h>
 #define Linux 1
 #define IRIX 2
 #define IRIX64 3
diff --git a/ccx_2.11/src/Makefile b/ccx_2.11/src/Makefile
index 9335028..d7791f1 100755
--- a/ccx_2.11/src/Makefile
+++ b/ccx_2.11/src/Makefile
@@ -25,7 +25,7 @@ LIBS = \
	../../../ARPACK/libarpack_INTEL.a \
        -lpthread -lm -lc

-ccx_2.11: $(OCCXMAIN) ccx_2.11.a  $(LIBS)
+ccx_2.11: $(OCCXMAIN) ccx_2.11.a
	./date.pl; $(CC) $(CFLAGS) -c ccx_2.11.c; $(FC) -fopenmp -Wall -O3 -o $@ $(OCCXMAIN) ccx_2.11.a $(LIBS)

 ccx_2.11.a: $(OCCXF) $(OCCXC)
diff --git a/ccx_2.11/src/u_free.c b/ccx_2.11/src/u_free.c
index acccf3b..da517de 100644
--- a/ccx_2.11/src/u_free.c
+++ b/ccx_2.11/src/u_free.c
@@ -41,5 +41,5 @@ void *u_free(void* ptr,const char *file,const int line, const char* ptr_name){
   if(log_realloc==1) {
       printf("FREEING of variable %s, file %s, line=%d: oldaddress= %ld\n",ptr_name,file,line,(long int)ptr);
   }      
-  return;
+  return NULL;
 }
