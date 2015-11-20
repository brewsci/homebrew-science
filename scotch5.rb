class Scotch5 < Formula
  homepage "https://gforge.inria.fr/projects/scotch"
  url "https://gforge.inria.fr/frs/download.php/28978"
  version "5.1.12b"
  sha1 "3866deea3199bc364d31ec46c63adcb799a8cf48"

  bottle do
    cellar :any
    sha256 "47c553dce7da037ad291ce82b8ba2a5f1bce90ccf27168b67132e0e0c7915f86" => :yosemite
    sha256 "ab718b8c7215be2734ddb98cccf46761077b623d2b69ce9ba4eddb0857646fbe" => :mavericks
    sha256 "565b19c1b337a74ffcc3c481d0221e1665eb7193352c32c15a7c0290babf3008" => :mountain_lion
  end

  depends_on :mpi => :cc

  keg_only "Conflicts with scotch (6.x)"

  # bugs in makefile:
  # - libptesmumps must be built before main_esmumps
  # - install should also install the lib*esmumps.a libraries
  patch :DATA

  def install
    cd "src" do
      # Use mpicc to compile the parallelized version
      make_args = ["CCS=#{ENV["CC"]}",
                   "CCP=#{ENV["MPICC"]}",
                   "CCD=#{ENV["MPICC"]}",
                   "RANLIB=echo"]
      if OS.mac?
        ln_s "Make.inc/Makefile.inc.i686_mac_darwin8", "Makefile.inc"
        make_args += ["LIB=.dylib",
                      "AR=libtool",
                      "ARFLAGS=-dynamic -install_name #{lib}/$(notdir $@) -undefined dynamic_lookup -o "]
      else
        ln_s "Make.inc/Makefile.inc.x86-64_pc_linux2", "Makefile.inc"
        make_args += ["LIB=.so",
                      "AR=$(CCS)",
                      "ARFLAGS=-shared -Wl,-soname -Wl,#{lib}/$(notdir $@) -o "]
      end
      inreplace "Makefile.inc" do |s|
        s.gsub! "-O3", "-O3 -fPIC"
      end

      system "make", "scotch", *make_args
      system "make", "ptscotch", *make_args
      system "make", "install", "prefix=#{prefix}", *make_args
    end
  end
end

__END__
diff -rupN scotch_5.1.12_esmumps/src/Makefile scotch_5.1.12_esmumps.patched/src/Makefile
--- scotch_5.1.12_esmumps/src/Makefile	2011-02-12 12:06:58.000000000 +0100
+++ scotch_5.1.12_esmumps.patched/src/Makefile	2013-08-07 14:56:06.000000000 +0200
@@ -105,6 +105,7 @@ install				:	required	$(bindir)	$(includ
 					-$(CP) -f ../bin/[agm]*$(EXE) $(bindir)
 					-$(CP) -f ../include/*scotch*.h $(includedir)
 					-$(CP) -f ../lib/*scotch*$(LIB) $(libdir)
+					-$(CP) -f ../lib/*esmumps*$(LIB) $(libdir)
 					-$(CP) -Rf ../man/* $(mandir)
 
 clean				:	required
diff -rupN scotch_5.1.12_esmumps/src/esmumps/Makefile scotch_5.1.12_esmumps.patched/src/esmumps/Makefile
--- scotch_5.1.12_esmumps/src/esmumps/Makefile	2010-07-02 23:31:06.000000000 +0200
+++ scotch_5.1.12_esmumps.patched/src/esmumps/Makefile	2013-08-07 14:48:30.000000000 +0200
@@ -59,7 +59,8 @@ scotch				:	clean
 
 ptscotch			:	clean
 					$(MAKE) CFLAGS="$(CFLAGS) -DSCOTCH_PTSCOTCH" CC=$(CCP) SCOTCHLIB=ptscotch ESMUMPSLIB=ptesmumps	\
-					libesmumps$(LIB)										\
+					libesmumps$(LIB)
+					$(MAKE) CFLAGS="$(CFLAGS) -DSCOTCH_PTSCOTCH" CC=$(CCP) SCOTCHLIB=ptscotch ESMUMPSLIB=ptesmumps	\
 					main_esmumps$(EXE)
 
 install				:
