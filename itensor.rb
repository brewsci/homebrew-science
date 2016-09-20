class Itensor < Formula
  desc "C++ library for implementing tensor product wavefunction calculations"
  homepage "http://itensor.org/"
  url "https://github.com/ITensor/ITensor/archive/v2.0.11.tar.gz"
  sha256 "07c4cc4a0c7c3fa2832f249ce5d1d81ffc66a28deb8b53e03dc00c76431262e5"
  head "https://github.com/ITensor/ITensor.git"

  bottle do
    cellar :any
    sha256 "9b1735cc1ca66d95b98b127471ca898d5fd9cbfe212cae444ef65a6efe604cf2" => :el_capitan
    sha256 "4e6b3c30fbeaa8e62306fb41a6881c23fa9416a4e9229a0eb3de998fda65a705" => :yosemite
    sha256 "3ac47b1e2e86069285083cbbe4a3f723e794f38ec3ed395238b4458a3e78f29e" => :mavericks
  end

  depends_on "openblas" => (OS.mac? ? :optional : :recommended)

  needs :cxx11

  patch :DATA

  def install
    if OS.mac?
      dylib_ext = "dylib"
      dylib_flags = "-dynamiclib -current_version #{version} -compatibility_version 1.0.0"
    else
      dylib_ext = "so"
      dylib_flags = "-shared"
    end

    if build.with? "openblas"
      platform = "openblas"
      openblas_dir = Formula["openblas"].opt_prefix
      blas_lapack_libflags = "-lpthread -L#{openblas_dir}/lib -lopenblas"
      blas_lapack_includeflags = "-I#{openblas_dir}/include -DHAVE_LAPACK_CONFIG_H -DLAPACK_COMPLEX_STRUCTURE"
    elsif OS.mac?
      platform="macos"
      blas_lapack_libflags = "-framework Accelerate"
      blas_lapack_includeflags = ""
    else
      platform="lapack"
      blas_lapack_libflags = "-llapack -lblas"
      blas_lapack_includeflags = ""
    end

    (buildpath/"itensor/platform.h").write <<-EOS.undent
      #ifndef __ITENSOR_PLATFORM_H
      #define __ITENSOR_PLATFORM_H

      #define PLATFORM_#{platform}

      #endif
    EOS

    (buildpath/"options.mk").write <<-EOS.undent
      CCCOM=#{ENV.cxx} -std=c++11 -fPIC
      BLAS_LAPACK_LIBFLAGS=#{blas_lapack_libflags}
      BLAS_LAPACK_INCLUDEFLAGS=#{blas_lapack_includeflags}
      OPTIMIZATIONS=-O2 -DNDEBUG -Wall
      DEBUGFLAGS=-DDEBUG -g -Wall -pedantic
      PREFIX=#{prefix}
      ITENSOR_LIBDIR=#{lib}
      ITENSOR_INCLUDEDIR=#{buildpath}
      OPTIMIZATIONS+= -D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0
      DEBUGFLAGS+= -D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0
      ITENSOR_INCLUDEFLAGS=-I$(ITENSOR_INCLUDEDIR) $(BLAS_LAPACK_INCLUDEFLAGS)
      CCFLAGS=-I. $(ITENSOR_INCLUDEFLAGS) $(OPTIMIZATIONS) -Wno-unused-variable
      CCGFLAGS=-I. $(ITENSOR_INCLUDEFLAGS) $(DEBUGFLAGS)
      DYLIB_EXT=#{dylib_ext}
      DYLIB_FLAGS=#{dylib_flags}
    EOS

    lib.mkpath
    system "make"

    include.mkpath
    ["itensor",
     "itensor/detail",
     "itensor/mps",
     "itensor/mps/lattice",
     "itensor/mps/sites",
     "itensor/itdata",
     "itensor/tensor",
     "itensor/util"].each do |p|
      (include + p).mkpath
      (include + p).install Dir["#{p}/*.h", "#{p}/*.ih"]
    end
  end

  test do
    if build.with? "openblas"
      openblas_dir = Formula["openblas"].opt_prefix
      blas_lapack_flags = ["-I#{openblas_dir}/include" , "-DHAVE_LAPACK_CONFIG_H", "-DLAPACK_COMPLEX_STRUCTURE",
                           "-lpthread", "-L#{openblas_dir}/lib", "-lopenblas"]
    elsif OS.mac?
      blas_lapack_flags = ["-framework", "Accelerate"]
    else
      blas_lapack_flags = ["-llapack", "-lblas"]
    end

    (testpath/"test.cc").write <<-EOS.undent
      #include "itensor/all.h"
      using namespace itensor;
      int main()
      {
          Index site("spin", 2, Site);
          printfln("%d", site.m());
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-o", "test",
        "-I#{include}", "-L#{lib}", "-litensor", *blas_lapack_flags
    assert_match "2", shell_output("./test")
  end
end
__END__
diff --git a/itensor/Makefile b/itensor/Makefile
index 8d0872b..6d74f4e 100644
--- a/itensor/Makefile
+++ b/itensor/Makefile
@@ -73,14 +73,22 @@ libitensor-g.a: mkdebugdir $(GOBJECTS)
	@ar r $(ITENSOR_LIBDIR)/libitensor-g.a $(GOBJECTS)
	@ranlib $(ITENSOR_LIBDIR)/libitensor-g.a

+libitensor.$(DYLIB_EXT): $(OBJECTS)
+	@echo "Building dynamic library $(ITENSOR_LIBDIR)/libitensor.$(DYLIB_EXT)"
+	@$(CCCOM) $(DYLIB_FLAGS) -o $(ITENSOR_LIBDIR)/libitensor.$(DYLIB_EXT) $(OBJECTS) $(BLAS_LAPACK_LIBFLAGS)
+
+libitensor-g.$(DYLIB_EXT): mkdebugdir $(GOBJECTS)
+	@echo "Building dynamic library $(ITENSOR_LIBDIR)/libitensor-g.$(DYLIB_EXT)"
+	@$(CCCOM) $(DYLIB_FLAGS) -o $(ITENSOR_LIBDIR)/libitensor-g.$(DYLIB_EXT) $(GOBJECTS) $(BLAS_LAPACK_LIBFLAGS)
+
 touch_all_headers:
	@touch all.h
	@touch all_basic.h
	@touch all_mps.h

-build: libitensor.a touch_all_headers
+build: libitensor.a libitensor.$(DYLIB_EXT) touch_all_headers

-debug: libitensor-g.a touch_all_headers
+debug: libitensor-g.a libitensor-g.$(DYLIB_EXT) touch_all_headers

 mkdebugdir:
	@mkdir -p .debug_objs
diff --git a/itensor/tensor/lapack_wrap.h b/itensor/tensor/lapack_wrap.h
index 2de9d96..898810c 100644
--- a/itensor/tensor/lapack_wrap.h
+++ b/itensor/tensor/lapack_wrap.h
@@ -6,6 +6,7 @@
 #define __ITENSOR_LAPACK_WRAP_h

 #include <vector>
+#include "itensor/platform.h"
 #include "itensor/types.h"
 #include "itensor/util/timers.h"
