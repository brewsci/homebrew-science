class Itensor < Formula
  desc "C++ library for implementing tensor product wavefunction calculations"
  homepage "http://itensor.org/"
  url "https://github.com/ITensor/ITensor/archive/v2.1.1.tar.gz"
  sha256 "b91a67af66ed0fa7678494f3895b5d5ae7f1dc1026540689f9625f515cb7791c"
  head "https://github.com/ITensor/ITensor.git"

  bottle do
    cellar :any
    sha256 "adfd2ddce1898aafd8a82f0150e1adac148e5eb7d177a0203437b5947190708b" => :sierra
    sha256 "cf5e854aa45d1e2d233e9e4017360f517b97947e1b14b2b57b86b0dff98cce6c" => :el_capitan
    sha256 "87b72c913c0fe34e2e9de07d5c51572e5fcba17ecb6602c3c6970a49a8f6d774" => :yosemite
    sha256 "f15f69aea74013c54daf78b5bfcdfd7ada5c366f904967dc31fe8bdbb190fb4d" => :x86_64_linux
  end

  depends_on "openblas" => (OS.mac? ? :optional : :recommended)

  needs :cxx11

  def install
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

    (buildpath/"options.mk").write <<-EOS.undent
      CCCOM=#{ENV.cxx} -std=c++11 -fPIC
      PLATFORM=#{platform}
      BLAS_LAPACK_LIBFLAGS=#{blas_lapack_libflags}
      BLAS_LAPACK_INCLUDEFLAGS=#{blas_lapack_includeflags}
      OPTIMIZATIONS=-O2 -DNDEBUG -Wall
      DEBUGFLAGS=-DDEBUG -g -Wall -pedantic
      ITENSOR_MAKE_DYLIB=1
      PREFIX=#{prefix}
      ITENSOR_LIBDIR=#{lib}
      ITENSOR_INCLUDEDIR=#{buildpath}

      ITENSOR_LIBNAMES=itensor
      ITENSOR_LIBFLAGS=$(patsubst %,-l%, $(ITENSOR_LIBNAMES))
      ITENSOR_LIBFLAGS+= $(BLAS_LAPACK_LIBFLAGS)
      ITENSOR_LIBGFLAGS=$(patsubst %,-l%-g, $(ITENSOR_LIBNAMES))
      ITENSOR_LIBGFLAGS+= $(BLAS_LAPACK_LIBFLAGS)
      ITENSOR_LIBS=$(patsubst %,$(ITENSOR_LIBDIR)/lib%.a, $(ITENSOR_LIBNAMES))
      ITENSOR_GLIBS=$(patsubst %,$(ITENSOR_LIBDIR)/lib%-g.a, $(ITENSOR_LIBNAMES))
      ITENSOR_INCLUDEFLAGS=-I$(ITENSOR_INCLUDEDIR) $(BLAS_LAPACK_INCLUDEFLAGS)

      CCFLAGS=-I. $(ITENSOR_INCLUDEFLAGS) $(OPTIMIZATIONS) -Wno-unused-variable
      CCGFLAGS=-I. $(ITENSOR_INCLUDEFLAGS) $(DEBUGFLAGS)
      LIBFLAGS=-L$(ITENSOR_LIBDIR) $(ITENSOR_LIBFLAGS)
      LIBGFLAGS=-L$(ITENSOR_LIBDIR) $(ITENSOR_LIBGFLAGS)

      UNAME_S := $(shell uname -s)
      ifeq ($(UNAME_S),Darwin)
        DYLIB_EXT ?= dylib
        DYLIB_FLAGS ?= -dynamiclib
      else
        DYLIB_EXT ?= so
        DYLIB_FLAGS ?= -shared
      endif
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
          Index i("i", 2), j("j", 2);
          ITensor t(i,j), u(i), s, v;
          t.fill(1.0);
          svd(t, u, s, v);
          printfln("%.2f", norm(s));
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-o", "test",
        "-I#{include}", "-L#{lib}", "-litensor", *blas_lapack_flags
    assert_match "2.00", shell_output("./test").chomp
  end
end
