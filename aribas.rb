class Aribas < Formula
  desc "Interactive interpreter for integer and multi-precision arithmetic"
  homepage "https://www.mathematik.uni-muenchen.de/~forster/sw/aribas.html"
  url "ftp://ftp.mathematik.uni-muenchen.de/pub/forster/aribas/UNIX_LINUX/aribas-1.64.tar.gz"
  sha256 "11b2a934774088e2c66a9d9397806dbb8d33f0da48d6c800a492c2a43c258169"

  bottle do
    cellar :any
    sha256 "527b9121f9ac87e6baaba446946dd0c77852f592591c152789aaa04f2e8cd2da" => :yosemite
    sha256 "488254a6933194e7d6df5003ade3b24e09e1f98fd00b0adf697a1859a7ff26fd" => :mavericks
    sha256 "86c8efd01bc594f1857dc84fa638412f9918b2851d59361198f74cfb3d0ef63a" => :mountain_lion
  end

  # Build a 32-bit binary because 64-bit builds can segfault.
  patch :DATA

  def install
    # Prevent "-m32" from being removed from C compiler args.
    ENV.m32

    cd "src" do
      system "make"
      bin.install "aribas"
    end
  end

  test do
    # ftp://ftp.mathematik.uni-muenchen.de/pub/forster/aribas/examples/pi.ari
    (testpath/"pi.ari").write <<-EOS.undent
      function Saux(zz)
      const
          k1 = 545140134;
          k2 = 13591409;
          k4 = 100100025;
          k5 = 327843840;
      var
          A, n: integer;
          S: integer;
      begin
          A := zz*k1;
          S := A * k2;
          n := 1;
          while A > 0 do
              A := A * ((6*n-5)*(6*n-3)*(6*n-1));
              A := A div (n*n*n);
              A := A div (k4*k5);
              if even(n) then
                  S := S + A * (k2 + n*k1);
              else
                  S := S - A * (k2 + n*k1);
              end;
              inc(n);
          end;
          return S div k1;
      end;

      function pi_chud(n: integer): integer;
      const
          k3 = 640320;
          k6 = 53360;
      var
          zz: integer;
          x: integer;
      begin
          zz := 2**16 * 10**n;
          x := isqrt(zz*zz*k3)*k6;
          x := (zz * x) div Saux(zz);
          return (x div 2**16);
      end;

      pi_chud(50).

      exit.
    EOS
    system "#{bin}/aribas pi.ari | grep -q 3_14159_26535_89793_23846_26433_83279_50288_41971_69399_37510"
  end
end

__END__
diff --unified a/src/Makefile b/src/Makefile
--- a/src/Makefile	2010-01-25 12:39:22.000000000 -0500
+++ b/src/Makefile	2013-12-30 09:45:26.000000000 -0500
@@ -12,7 +12,8 @@
 # the next two lines.

 CC = gcc
-CFLAGS = -DUNiX -DPROTO -O -v
+CFLAGS = -m32 -DUNiX -DPROTO -O -v
+LDFLAGS = -m32

 MEMFLAG1 = -DMEM=16
 # MEM may be set to any integer value from 1 to 32.
@@ -20,7 +21,7 @@
 # The value should not exceed one half of the RAM of your machine
 # If MEMFLAG is not defined, MEM=2 will be used by default

-MEMFLAG2 = -DINTSIZE=64
+MEMFLAG2 = -DINTSIZE=32
 MEMFLAG = $(MEMFLAG1) $(MEMFLAG2)

 OBJECTS = alloc.o analysis.o aritaux.o arith.o aritool0.o \
@@ -43,7 +44,7 @@
	$(CC) $(CFLAGS) $(MEMFLAG) -c alloc.c

 $(PROGRAM): $(OBJECTS)
-	$(CC) -o $(PROGRAM) $(OBJECTS)
+	$(CC) $(LDFLAGS) -o $(PROGRAM) $(OBJECTS)
	strip $(PROGRAM)
 clean:
	\rm *.o
