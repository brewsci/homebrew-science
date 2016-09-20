class Itensor < Formula
  desc "C++ library for implementing tensor product wavefunction calculations"
  homepage "http://itensor.org/"
  url "https://github.com/ITensor/ITensor/archive/v2.0.11.tar.gz"
  sha256 "07c4cc4a0c7c3fa2832f249ce5d1d81ffc66a28deb8b53e03dc00c76431262e5"
  head "https://github.com/ITensor/ITensor.git"

  bottle do
    cellar :any
    sha256 "3a9d5184cd98a27afc9a2cfab5219b760842dc0f7db6e85fcffb3efaf1196d66" => :sierra
    sha256 "439d0509cf565f1fa4c0e3180320c5d8580c53b7ce8b8618c36b290c6523b5d3" => :el_capitan
    sha256 "903a3f2dc410cdcf85d9bcd7a4694c46f0cd49c58931fa102849a1c60a9557f7" => :yosemite
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
      blas_lapack_flags = ["-I#{openblas_dir}/include", "-DHAVE_LAPACK_CONFIG_H", "-DLAPACK_COMPLEX_STRUCTURE",
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
