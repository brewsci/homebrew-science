class Libeemd < Formula
  desc "Library for performing the ensemble empirical mode decomposition"
  homepage "https://bitbucket.org/luukko/libeemd"
  url "https://bitbucket.org/luukko/libeemd/get/v1.4.tar.gz"
  sha256 "c484f4287f4469f3ac100cf4ecead8fd24bf43854efa63650934dd698d6b298b"
  head "https://bitbucket.org/luukko/libeemd.git"
  # doi "10.1007/s00180-015-0603-9"

  bottle do
    cellar :any
    sha256 "071ec8487eb593553d0afe62e14f53f7c9c533922e520015e3bfee9f90b152cb" => :sierra
    sha256 "58ca938d5577cdedc26943d7badcdfe6c86a6e3710b0022bb9a4bdf74d6c1acb" => :el_capitan
    sha256 "003419ec5ee70b9b7aa3606b4e3199e9a6427cd20689db6995519cb0a0a38d23" => :yosemite
    sha256 "599aa4e28bfe2136a38b3289d5254189091f856fb0d48ebf40fafaf1d578c0cb" => :x86_64_linux
  end

  depends_on "gsl"
  depends_on "pkg-config" => :build

  needs :openmp

  # The patch fixes the Makefile build option to use the -dynamiclib
  # option instead of the -shared option when making a macOS dynamic
  # link library and also fixes the dynamic link library suffix name
  # to follow the name convention used in macOS. Since the original
  # Makefile does not support multi-platform configuration, we handle
  # this with a local patch until the original author switches to use
  # autoconf or some other flexible build environment adaptation
  # tools.
  patch :DATA

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <math.h>
      #include <stdio.h>
      #include <stdlib.h>

      #include <gsl/gsl_math.h>
      #include <eemd.h>

      const size_t ensemble_size = 250;
      const unsigned int S_number = 4;
      const unsigned int num_siftings = 50;
      const double noise_strength = 0.2;
      const unsigned long int rng_seed = 0;

      const size_t N = 1024;
      static inline double input_signal(double x) {
        const double omega = 2*M_PI/(N-1);
        return sin(17*omega*x)+0.5*(1.0-exp(-0.002*x))*sin(51*omega*x+1);
      }

      int main(void) {
        libeemd_error_code err;
        double* inp = malloc(N*sizeof(double));
        for (size_t i=0; i<N; i++) {
          inp[i] = input_signal((double)i);
        }
        size_t M = emd_num_imfs(N);
        double* outp = malloc(M*N*sizeof(double));
        err = eemd(inp, N, outp, M, ensemble_size, noise_strength,
                   S_number, num_siftings, rng_seed);
        if (err != EMD_SUCCESS) {
          return -1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-leemd", "-o", "test"
    system "./test"
  end
end

__END__
--- a/Makefile	2016-09-19 16:58:13.000000000 +0900
+++ b/Makefile	2016-12-08 11:50:50.000000000 +0900
@@ -23,7 +23,7 @@
 endef
 export uninstall_msg

-all: libeemd.so.$(version) libeemd.a eemd.h
+all: libeemd.$(version).dylib libeemd.a eemd.h

 clean:
	rm -f libeemd.so libeemd.so.$(version) libeemd.a eemd.h obj/eemd.o
@@ -34,8 +34,8 @@
	install -d $(PREFIX)/lib
	install -m644 eemd.h $(PREFIX)/include
	install -m644 libeemd.a $(PREFIX)/lib
-	install libeemd.so.$(version) $(PREFIX)/lib
-	cp -Pf libeemd.so $(PREFIX)/lib
+	install libeemd.$(version).dylib $(PREFIX)/lib
+	cp -Pf libeemd.dylib $(PREFIX)/lib

 uninstall:
	@echo "$$uninstall_msg"
@@ -49,9 +49,9 @@
 libeemd.a: obj/eemd.o
	$(AR) rcs $@ $^

-libeemd.so.$(version): src/eemd.c src/eemd.h
-	gcc $(commonflags) $< -fPIC -shared -Wl,$(SONAME),$@ $(gsl_flags) -o $@
-	ln -sf $@ libeemd.so
+libeemd.$(version).dylib: src/eemd.c src/eemd.h
+	gcc $(commonflags) $< -fPIC -dynamiclib -Wl,$(SONAME),$@ $(gsl_flags) -o $@
+	ln -sf $@ libeemd.dylib

 eemd.h: src/eemd.h
	cp $< $@
