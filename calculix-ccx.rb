class CalculixCcx < Formula
  desc "Three-Dimensional Finite Element Solver"
  homepage "http://www.calculix.de/"
  url "http://www.dhondt.de/ccx_2.12.src.tar.bz2"
  version "2.12"
  sha256 "d75427dfb6db70fdfbb5939df22da8addf0ea4522cff32c9cdc4029e39b6b914"

  bottle do
    cellar :any
    sha256 "fc8cb47884622d5b44d2ed6b1dec16fce6213b00776de4e4582271fb388a8788" => :sierra
    sha256 "499ced02ee2beb9f77dc7b435c794c03734d52d5d1ec5ed533a4443053f77cef" => :el_capitan
    sha256 "3e3391c14666e4febb7f2d478a6fdfefd6e381860b52dd0c0d6eae43b8d9514c" => :yosemite
    sha256 "a6ccbc1e7215d521e168327b1942f27960bb632e52538dc8728e4a0a8c4ffe5e" => :x86_64_linux
  end

  option "with-openmp", "build with OpenMP support"
  needs :openmp if build.with? "openmp"

  depends_on :fortran
  depends_on "arpack"
  depends_on "pkg-config" => :build

  resource "test" do
    url "http://www.dhondt.de/ccx_2.12.test.tar.bz2"
    version "2.12"
    sha256 "1a3758a09a444472bccf0998ae66d3f78671c9fd8a3c8a8fe59372e9b5787bd8"
  end

  resource "doc" do
    url "http://www.dhondt.de/ccx_2.12.htm.tar.bz2"
    version "2.12"
    sha256 "79f16a016d37ae8b1599946dbbeb56fc256ba848413fa8ccfbab5b565b41a9e9"
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
    inreplace "ccx_2.12/src/Makefile", "-fopenmp", "" if build.without? "openmp"

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
    target = Pathname.new("ccx_2.12/src/ccx_2.12")
    system "make", "-C", target.dirname, target.basename, *args
    bin.install target

    (buildpath/"test").install resource("test")
    pkgshare.install Dir["test/ccx_2.12/test/*"]

    (buildpath/"doc").install resource("doc")
    doc.install Dir["doc/ccx_2.12/doc/ccx/*"]
  end

  test do
    cp "#{pkgshare}/spring1.inp", testpath
    system "#{bin}/ccx_2.12", "spring1"
  end
end

__END__
diff --git a/ccx_2.12/src/CalculiX.h b/ccx_2.12/src/CalculiX.h
index ee81ca8..d957130 100644
--- a/ccx_2.12/src/CalculiX.h
+++ b/ccx_2.12/src/CalculiX.h
@@ -15,6 +15,7 @@
 /*     along with this program; if not, write to the Free Software       */
 /*     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.         */

+#include <pthread.h>
 #define Linux 1
 #define IRIX 2
 #define IRIX64 3
diff --git a/ccx_2.12/src/Makefile b/ccx_2.12/src/Makefile
index 9335028..d7791f1 100755
--- a/ccx_2.12/src/Makefile
+++ b/ccx_2.12/src/Makefile
@@ -25,7 +25,7 @@ LIBS = \
	../../../ARPACK/libarpack_INTEL.a \
        -lpthread -lm -lc

-ccx_2.12: $(OCCXMAIN) ccx_2.12.a  $(LIBS)
+ccx_2.12: $(OCCXMAIN) ccx_2.12.a
	./date.pl; $(CC) $(CFLAGS) -c ccx_2.12.c; $(FC) -fopenmp -Wall -O3 -o $@ $(OCCXMAIN) ccx_2.12.a $(LIBS)

 ccx_2.12.a: $(OCCXF) $(OCCXC)
diff --git a/ccx_2.12/src/u_free.c b/ccx_2.12/src/u_free.c
index acccf3b..da517de 100644
--- a/ccx_2.12/src/u_free.c
+++ b/ccx_2.12/src/u_free.c
@@ -41,5 +41,5 @@ void *u_free(void* ptr,const char *file,const int line, const char* ptr_name){
   if(log_realloc==1) {
       printf("FREEING of variable %s, file %s, line=%d: oldaddress= %ld\n",ptr_name,file,line,(long int)ptr);
   }      
-  return;
+  return NULL;
 }
