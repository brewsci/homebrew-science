class Hopdm < Formula
  homepage "http://www.maths.ed.ac.uk/~gondzio/software/hopdm.html"
  url "http://dl.dropbox.com/u/72178/dist/hopdm-2.13.tar.gz"
  sha256 "84f1a265612fb96ee2ee1a645dbef2deeb66b798c5909e9c26670341814817fe"
  revision 3

  bottle do
    cellar :any
    sha256 "a6fa19ffd74910c61fdac2244397d8f3dfa5e5eaf11b131a340cb683b2c59ff3" => :el_capitan
    sha256 "0166c1b332eff3c80b4fb77a110bb66478f997d484582d21c0ea11c6a5d98020" => :yosemite
    sha256 "65c8c7ce0860bdd980d1e6280c3ea9a630c8acb5ff70c16632b4be4f69b56579" => :mavericks
  end

  depends_on :fortran

  patch :DATA

  def install
    inreplace "makefile" do |s|
      s.remove_make_var! "FC"
      s.change_make_var! "LIBS", "-Wl,-framework -Wl,Accelerate"
      s.remove_make_var! "FFLAGS"
      s.remove_make_var! "LDFLAGS"
      s.remove_make_var! "CC"
      s.remove_make_var! "CFLAGS"
      s.remove_make_var! "COBJS"
    end

    system "make"
    bin.install "hopdm"
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
