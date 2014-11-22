require 'formula'

class Hopdm < Formula
  homepage 'http://www.maths.ed.ac.uk/~gondzio/software/hopdm.html'
  url 'http://dl.dropbox.com/u/72178/dist/hopdm-2.13.tar.gz'
  sha1 '5d4df64f1a03251c0c22f9d292c26da2f2cea1eb'
  revision 1

  depends_on :fortran

  patch :DATA

  def install
    inreplace 'makefile' do |s|
      s.remove_make_var! 'FC'
      s.change_make_var! 'LIBS', '-Wl,-framework -Wl,Accelerate'
      s.remove_make_var! 'FFLAGS'
      s.remove_make_var! 'LDFLAGS'
      s.remove_make_var! 'CC'
      s.remove_make_var! 'CFLAGS'
      s.remove_make_var! 'COBJS'
    end

    system 'make'
    bin.install 'hopdm'
  end
end

__END__
Patch to disable timing routines.

diff --git a/mytime.f b/mytime.f
index 55bdaaa..ce024fe 100644
--- a/mytime.f
+++ b/mytime.f
@@ -25,17 +25,17 @@ C     SECONDS to store the elapsed time.
 C
 C
 C     Only for DOS
-      COMMON/IDTM/ IDATIM
-      INTEGER*4    IDATIM(9)
+C     COMMON/IDTM/ IDATIM
+C     INTEGER*4    IDATIM(9)
 C
 C     Only for SUN UNIX
-      COMMON /TIME/ ELTIME
-      REAL ELTIME(3)
+C     COMMON /TIME/ ELTIME
+C     REAL ELTIME(3)
 C
 C     Only for IBM UNIX 
-      COMMON /TIMIBM/ T1,T2
-      DOUBLE PRECISION T1,T2
-      DOUBLE PRECISION SECONDS
+C     COMMON /TIMIBM/ T1,T2
+C     DOUBLE PRECISION T1,T2
+C     DOUBLE PRECISION SECONDS
 C
 C
 C *** PARAMETERS DESCRIPTION
@@ -74,16 +74,16 @@ C
 C
 C     Here for UNIX (IBM RISC6000 and Power PC workstations)
 C     ------------------------------------------------------
-      IF(JOB.EQ.0) THEN 
-         call init_seconds()
-         T1 = seconds()
-         T2 = T1
-      ELSE
-         T2 = seconds()
-      ENDIF
-      WRITE(BUFFER,101) (T2 - T1)
-  101 format(1X,'MYTIME: Elapsed user time:',F12.2)
-      CALL MYWRT(IOLOG,BUFFER)
+C     IF(JOB.EQ.0) THEN 
+C        call init_seconds()
+C        T1 = seconds()
+C        T2 = T1
+C     ELSE
+C        T2 = seconds()
+C     ENDIF
+C     WRITE(BUFFER,101) (T2 - T1)
+C 101 format(1X,'MYTIME: Elapsed user time:',F12.2)
+C     CALL MYWRT(IOLOG,BUFFER)
 C
 C
 C
