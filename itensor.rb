class Itensor < Formula
  desc "C++ library for implementing tensor product wavefunction calculations"
  homepage "http://itensor.org/"
  url "https://github.com/ITensor/ITensor/archive/v2.1.0.tar.gz"
  sha256 "3a3c0fb5b93dfe38ef00a07bb30266f5a79bda0917f5202de900eb54a0b58188"
  head "https://github.com/ITensor/ITensor.git"

  bottle do
    cellar :any
    sha256 "8b6b7071ed6e384d98dea1d037c3c70a83512ca1cb03590d822d1b1b7880229c" => :sierra
    sha256 "2f485cbad4d758d765b44680663c32773929cb555434cb675f211900157f370b" => :el_capitan
    sha256 "949af2c2f49d93b95932bd68c113f487dc5fff26b882f9cd99b4642b20c3045e" => :yosemite
    sha256 "79bbb3e26dde985c11a0153610e47eb379f3812b80c0c42a73499d5d96aee8cd" => :x86_64_linux
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
