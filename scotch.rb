require 'formula'

class Scotch < Formula
  homepage 'https://gforge.inria.fr/projects/scotch'
  url 'https://gforge.inria.fr/frs/download.php/31831/scotch_6.0.0.tar.gz'
  sha1 'eb32d846bb14449245b08c81e740231f7883fea6'

  option 'without-check', 'skip build-time tests (not recommended)'

  depends_on :mpi => :cc

  def patches # See http://goo.gl/NY4MOy
    DATA
  end

  def install
    cd "src" do
      ln_s "Make.inc/Makefile.inc.i686_mac_darwin8", "Makefile.inc"

      make_args = ["CCS=#{ENV['CC']}",
                   "CCP=#{ENV['MPICC']}",
                   "CCD=#{ENV['MPICC']}",
                   "LIB=.dylib",
                   "AR=libtool",
                   "ARFLAGS=-dynamic -install_name #{lib}/$(notdir $@) -undefined dynamic_lookup -o ",
                   "RANLIB=echo"]

      inreplace "Makefile.inc" do |s|
        # OS X doesn't implement pthread_barriers required by Scotch
        s.slice! "-DCOMMON_PTHREAD"
        s.slice! "-DSCOTCH_PTHREAD"
        s.gsub! "-O3", "-O3 -fPIC"
      end

      system "make", "scotch", "VERBOSE=ON", *make_args
      system "make", "ptscotch", "VERBOSE=ON", *make_args
      system "make", "install", "prefix=#{prefix}", *make_args
      system "make", "check", "ptcheck", "EXECP=mpirun -np 2", *make_args if build.with? "check"
    end
  end
end

__END__
diff --git a/src/check/Makefile b/src/check/Makefile
index 2b3283a..73ee4ba 100644
--- a/src/check/Makefile
+++ b/src/check/Makefile
@@ -110,7 +110,7 @@ check_common_thread		:	test_common_thread
 					$(EXECS) ./test_common_thread
 
 test_common_thread		:	test_common_thread.c		\
-					$(SCOTCHLIBDIR)/libscotch.a
+					$(SCOTCHLIBDIR)/libscotch$(LIB)
 
 ##
 
@@ -118,7 +118,7 @@ check_graph_color		:	test_scotch_graph_color
 					$(EXECS) ./test_scotch_graph_color data/bump.grf
 
 test_graph_color		:	test_scotch_graph_color.c	\
-					$(SCOTCHLIBDIR)/libscotch.a
+					$(SCOTCHLIBDIR)/libscotch$(LIB)
 
 ##
 
@@ -126,7 +126,7 @@ check_strat_seq			:	test_strat_seq
 					$(EXECS) ./test_strat_seq
 
 test_strat_seq			:	test_strat_seq.c		\
-					$(SCOTCHLIBDIR)/libscotch.a
+					$(SCOTCHLIBDIR)/libscotch$(LIB)
 
 ##
 
@@ -134,7 +134,7 @@ check_strat_par			:	test_strat_par
 					$(EXECS) ./test_strat_par
 
 test_strat_par			:	test_strat_par.c		\
-					$(SCOTCHLIBDIR)/libptscotch.a
+					$(SCOTCHLIBDIR)/libptscotch$(LIB)
 
 ##
 
@@ -142,7 +142,7 @@ check_scotch_dgraph_band	:	test_scotch_dgraph_band
 					$(EXECP) ./test_scotch_dgraph_band data/bump.grf
 
 test_scotch_dgraph_band		:	test_scotch_dgraph_band.c	\
-					$(SCOTCHLIBDIR)/libptscotch.a
+					$(SCOTCHLIBDIR)/libptscotch$(LIB)
 
 ##
 
@@ -150,4 +150,4 @@ check_scotch_dgraph_grow	:	test_scotch_dgraph_grow
 					$(EXECP) ./test_scotch_dgraph_grow data/bump.grf
 
 test_scotch_dgraph_grow		:	test_scotch_dgraph_grow.c	\
-					$(SCOTCHLIBDIR)/libptscotch.a
+					$(SCOTCHLIBDIR)/libptscotch$(LIB)
diff --git a/src/check/test_scotch_dgraph_band.c b/src/check/test_scotch_dgraph_band.c
index 9dbd966..2edece6 100644
--- a/src/check/test_scotch_dgraph_band.c
+++ b/src/check/test_scotch_dgraph_band.c
@@ -99,10 +99,12 @@ char *              argv[])
     errorPrint ("main: Cannot initialize (1)");
     exit       (1);
   }
+#ifdef SCOTCH_PTHREAD
   if (thrdlvlreqval > thrdlvlproval) {
     errorPrint ("main: Cannot initialize (2)");
     exit       (1);
   }
+#endif
 
   if (argc != 2) {
     errorPrint ("main: invalid number of parameters");
@@ -115,12 +117,14 @@ char *              argv[])
 
   fprintf (stderr, "Proc %2d of %2d, pid %d\n", proclocnum, procglbnbr, getpid ());
 
+#ifdef SCOTCH_DEBUG_CHECK2
   if (proclocnum == 0) {                          /* Synchronize on keybord input */
     char           c;
 
     printf ("Waiting for key press...\n");
     scanf ("%c", &c);
   }
+#endif
 
   if (MPI_Barrier (proccomm) != MPI_SUCCESS) {    /* Synchronize for debug */
     errorPrint ("main: cannot communicate");
diff --git a/src/check/test_scotch_dgraph_grow.c b/src/check/test_scotch_dgraph_grow.c
index e074f83..56a5ebb 100644
--- a/src/check/test_scotch_dgraph_grow.c
+++ b/src/check/test_scotch_dgraph_grow.c
@@ -103,10 +103,12 @@ char *              argv[])
     errorPrint ("main: Cannot initialize (1)");
     exit       (1);
   }
+#ifdef SCOTCH_PTHREAD
   if (thrdlvlreqval > thrdlvlproval) {
     errorPrint ("main: Cannot initialize (2)");
     exit       (1);
   }
+#endif
 
   if (argc != 2) {
     errorPrint ("main: invalid number of parameters");
@@ -119,12 +121,14 @@ char *              argv[])
 
   fprintf (stderr, "Proc %2d of %2d, pid %d\n", proclocnum, procglbnbr, getpid ());
 
+#ifdef SCOTCH_DEBUG_CHECK2
   if (proclocnum == 0) {                          /* Synchronize on keybord input */
     char           c;
 
     printf ("Waiting for key press...\n");
     scanf ("%c", &c);
   }
+#endif
 
   if (MPI_Barrier (proccomm) != MPI_SUCCESS) {    /* Synchronize for debug */
     errorPrint ("main: cannot communicate");
diff --git a/src/check/test_scotch_dgraph_redist.c b/src/check/test_scotch_dgraph_redist.c
index 3c1d2e0..84f17e3 100644
--- a/src/check/test_scotch_dgraph_redist.c
+++ b/src/check/test_scotch_dgraph_redist.c
@@ -98,10 +98,12 @@ char *              argv[])
     errorPrint ("main: Cannot initialize (1)");
     exit       (1);
   }
+#ifdef SCOTCH_PTHREAD
   if (thrdlvlreqval > thrdlvlproval) {
     errorPrint ("main: Cannot initialize (2)");
     exit       (1);
   }
+#endif
 
   if (argc != 2) {
     errorPrint ("main: invalid number of parameters");
@@ -114,7 +116,6 @@ char *              argv[])
 
   fprintf (stderr, "Proc %2d of %2d, pid %d\n", proclocnum, procglbnbr, getpid ());
 
-#define SCOTCH_DEBUG_CHECK2
 #ifdef SCOTCH_DEBUG_CHECK2
   if (proclocnum == 0) {                          /* Synchronize on keybord input */
     char           c;

