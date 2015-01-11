class Scotch < Formula
  homepage "https://gforge.inria.fr/projects/scotch"
  url "https://gforge.inria.fr/frs/download.php/file/34099/scotch_6.0.3.tar.gz"
  sha1 "7bad26fbe2304759a77bd92348229876edcead1e"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "f86dcb86ef14e9861736f2e51f1d8e3675625ba0" => :yosemite
    sha1 "31f8ed4c57bc77a49ab1795c098b8a3edde0a5a4" => :mavericks
    sha1 "8cd53c51772977558b4d2b052769ec1243b71122" => :mountain_lion
  end

  option "without-check", "skip build-time tests (not recommended)"

  depends_on :mpi => :cc

  depends_on "xz"   => :optional  # Provides lzma compression.

  patch :DATA

  def install
    cd "src" do
      ln_s "Make.inc/Makefile.inc.i686_mac_darwin8", "Makefile.inc"

      cflags   = %w[-O3 -fPIC -Drestrict=__restrict -DCOMMON_PTHREAD_BARRIER
                    -DSCOTCH_CHECK_AUTO -DCOMMON_RANDOM_FIXED_SEED
                    -DCOMMON_TIMING_OLD -DSCOTCH_RENAME
                    -DCOMMON_FILE_COMPRESS_BZ2 -DCOMMON_FILE_COMPRESS_GZ]
      ldflags  = %w[-lm -lz -lbz2]

      cflags  += %w[-DCOMMON_FILE_COMPRESS_LZMA]   if build.with? "xz"
      ldflags += %W[-L#{Formula["xz"].lib} -llzma] if build.with? "xz"

      make_args = ["CCS=#{ENV["CC"]}",
                   "CCP=#{ENV["MPICC"]}",
                   "CCD=#{ENV["MPICC"]}",
                   "LIB=.dylib",
                   "AR=libtool",
                   "ARFLAGS=-dynamic -install_name #{lib}/$(notdir $@) -undefined dynamic_lookup -o ",
                   "RANLIB=echo",
                   "CFLAGS=#{cflags.join(" ")}",
                   "LDFLAGS=#{ldflags.join(" ")}"]

      system "make", "scotch", "VERBOSE=ON", *make_args
      system "make", "ptscotch", "VERBOSE=ON", *make_args
      system "make", "install", "prefix=#{prefix}", *make_args
      system "make", "check", "ptcheck", "EXECP=mpirun -np 2", *make_args if build.with? "check"
    end

    # Install documentation + sample graphs and grids.
    doc.install Dir["doc/*"]
    (share / "scotch").install "grf", "tgt"
  end

  test do
    mktemp do
      system "echo cmplt 7 | #{bin}/gmap #{share}/scotch/grf/bump.grf.gz - bump.map"
      system "#{bin}/gmk_m2 32 32 | #{bin}/gmap - #{share}/scotch/tgt/h8.tgt brol.map"
      system "#{bin}/gout -Mn -Oi #{share}/scotch/grf/4elt.grf.gz #{share}/scotch/grf/4elt.xyz.gz - graph.iv"
    end
  end
end

__END__
diff --git a/src/check/test_common_thread.c b/src/check/test_common_thread.c
index 8327bc7..a1d4243 100644
--- a/src/check/test_common_thread.c
+++ b/src/check/test_common_thread.c
@@ -197,11 +197,11 @@ char *              argv[])
     errorPrint ("main: cannot launch or run threads");
     return     (1);
   }
+
+  free (thrdtab);
 #else /* ((defined COMMON_PTHREAD) || (defined SCOTCH_PTHREAD)) */
   printf ("Scotch not compiled with either COMMON_PTHREAD or SCOTCH_PTHREAD\n");
 #endif /* ((defined COMMON_PTHREAD) || (defined SCOTCH_PTHREAD)) */
 
-  free (thrdtab);
-
   return (0);
 }
