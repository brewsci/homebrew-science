require 'formula'

class Scotch5 < Formula
  homepage 'https://gforge.inria.fr/projects/scotch'
  url 'https://gforge.inria.fr/frs/download.php/28978'
  version '5.1.12b'
  sha1 '3866deea3199bc364d31ec46c63adcb799a8cf48'

  depends_on :mpi => :cc

  keg_only "Conflicts with scotch (6.x)"

  def patches
    # bugs in makefile:
    # - libptesmumps must be built before main_esmumps
    # - install should also install the lib*esmumps.a libraries
    DATA
  end

  def install
    cd 'src' do
      ln_s 'Make.inc/Makefile.inc.i686_mac_darwin8', 'Makefile.inc'

      # Use mpicc to compile the parallelized version
      inreplace 'Makefile.inc' do |s|
        s.change_make_var! 'CCS', ENV['CC']
        s.change_make_var! 'CCP', ENV['MPICC']
        s.change_make_var! 'CCD', ENV['MPICC']
        s.gsub! '-O3', '-O3 -fPIC'
      end

      system 'make', 'scotch'
      system 'make', 'ptscotch'
      system 'make', 'install', "prefix=#{prefix}"
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
