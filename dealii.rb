class Dealii < Formula
  desc "open source finite element library"
  homepage "http://www.dealii.org"
  url "https://github.com/dealii/dealii/releases/download/v8.4.1/dealii-8.4.1.tar.gz"
  sha256 "00a0e92d069cdafd216816f1aff460f7dbd48744b0d9e0da193287ebf7d6b3ad"

  head do
    url "https://github.com/dealii/dealii.git"
  end

  bottle do
    cellar :any
    sha256 "592e2da96fcc9455cbacb2b12b446cab20fe9fc32dceea6e9412641339107e05" => :el_capitan
    sha256 "75b52df3214c1a6e9202ecfc301e03520152bfe3b407b45d2544ed066f2296dc" => :yosemite
    sha256 "d848dbc4d52e2ade5661ec076d90de3853ae7fcdcec17142992677caf6d770f2" => :mavericks
  end

  option "with-testsuite", "Run full test suite (7000+ tests). Takes a lot of time."

  depends_on "cmake"        => :run
  depends_on :mpi           => [:cc, :cxx, :f90, :recommended]
  depends_on "openblas"     => :optional

  openblasdep = (build.with? "openblas") ? ["with-openblas"] : []
  mpidep      = (build.with? "mpi")      ? ["with-mpi"]      : []

  depends_on "arpack"       => [:recommended] + mpidep + openblasdep
  depends_on "boost"        => :recommended
  #-depends_on "doxygen"      => :optional # installation error: CMake Error at doc/doxygen/cmake_install.cmake:31 (file)
  depends_on "hdf5"         => [:recommended] + mpidep
  depends_on "metis"        => :recommended
  depends_on "muparser"     => :recommended if MacOS.version != :mountain_lion # Undefined symbols for architecture x86_64
  depends_on "netcdf"       => [:recommended, "with-fortran", "with-cxx-compat"]
  depends_on "opencascade"  => :recommended
  depends_on "p4est"        => [:recommended] + openblasdep if build.with? "mpi"
  depends_on "parmetis"     => :recommended if build.with? "mpi"
  depends_on "petsc"        => [:recommended] + openblasdep
  depends_on "slepc"        => :recommended
  depends_on "suite-sparse" => [:recommended] + openblasdep
  depends_on "tbb"          => :recommended
  depends_on "trilinos"     => [:recommended] + openblasdep

  needs :cxx11
  def install
    ENV.cxx11

    # PETSc 3.7.x added a parameter to PetscOptionsSetValue()
    # https://bitbucket.org/petsc/petsc/src/5d547b27bccc01eacb9fc0eef6ae71e85dce2b0c/src/sys/objects/options.c?at=master&fileviewer=file-view-default#options.c-1078
    # See upstream PR: https://github.com/dealii/dealii/pull/2327
    inreplace "source/lac/petsc_precondition.cc",
      "PetscOptionsSetValue(\"",
      "PetscOptionsSetValue(NULL,\""

    args = %W[
      -DCMAKE_BUILD_TYPE=DebugRelease
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_FIND_FRAMEWORK=LAST
      -Wno-dev
      -DDEAL_II_COMPONENT_COMPAT_FILES=OFF
      -DDEAL_II_COMPONENT_EXAMPLES=ON
      -DDEAL_II_COMPONENT_MESH_CONVERTER=ON
    ]
    # constrain Cmake to look for libraries in homebrew's prefix
    args << "-DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}"

    args << "-DDEAL_II_COMPONENT_DOCUMENTATION=ON" if build.with? "doxygen"

    if build.with? "openblas"
      ext = OS.mac? ? "dylib" : "so"
      args << "-DLAPACK_FOUND=true"
      args << "-DLAPACK_INCLUDE_DIRS=#{Formula["openblas"].opt_include}"
      args << "-DLAPACK_LIBRARIES=#{Formula["openblas"].opt_lib}/libopenblas.#{ext}"
      args << "-DLAPACK_LINKER_FLAGS=-lgfortran -lm"
    end

    if build.with? "mpi"
      args << "-DCMAKE_C_COMPILER=mpicc"
      args << "-DCMAKE_CXX_COMPILER=mpicxx"
      args << "-DCMAKE_Fortran_COMPILER=mpif90"
    end

    args << "-DARPACK_DIR=#{Formula["arpack"].opt_prefix}" if build.with? "arpack"
    args << "-DBOOST_DIR=#{Formula["boost"].opt_prefix}" if build.with? "boost"
    args << "-DHDF5_DIR=#{Formula["hdf5"].opt_prefix}" if build.with? "hdf5"
    args << "-DMETIS_DIR=#{Formula["metis"].opt_prefix}" if build.with? "metis"
    args << "-DMUPARSER_DIR=#{Formula["muparser"].opt_prefix}" if build.with? "muparser"
    args << "-DNETCDF_DIR=#{Formula["netcdf"].opt_prefix}" if build.with? "netcdf"
    args << "-DOPENCASCADE_DIR=#{Formula["opencascade"].opt_prefix}" if build.with? "opencascade"
    args << "-DP4EST_DIR=#{Formula["p4est"].opt_prefix}" if build.with? "p4est"
    args << "-DPETSC_DIR=#{Formula["petsc"].opt_prefix}" if build.with? "petsc"
    args << "-DSLEPC_DIR=#{Formula["slepc"].opt_prefix}" if build.with? "slepc"
    args << "-DUMFPACK_DIR=#{Formula["suite-sparse"].opt_prefix}" if build.with? "suite-sparse"
    args << "-DTBB_DIR=#{Formula["tbb"].opt_prefix}" if build.with? "tbb"
    args << "-DTRILINOS_DIR=#{Formula["trilinos"].opt_prefix}" if build.with? "trilinos"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "test"
      if build.with? "testsuite"
        system "make", "setup_tests"
        system "ctest", "-j", Hardware::CPU.cores
      end
      system "make", "install"
    end
  end

  test do
    # take bare-bones step-3
    ohai "running step-3:"
    cp_r prefix/"examples/step-3", testpath
    cd "step-3" do
      system "cmake", "."
      system "make", "release"
      system "make", "run"
    end
    # take step-40 which can use both PETSc and Trilinos
    cp_r prefix/"examples/step-40", testpath
    if (build.with? "petsc") && (build.with? "trilinos")
      ohai "running step-40:"
      cd "step-40" do
        system "cmake", "."
        system "make", "release"
        if build.with? "mpi"
          system "mpirun", "-np", Hardware::CPU.cores, "step-40"
        else
          system "make", "run"
        end
        # change to Trilinos
        inreplace "step-40.cc", "#  define USE_PETSC_LA", "//#  define USE_PETSC_LA"
        system "make", "release"
        if build.with? "mpi"
          system "mpirun", "-np", Hardware::CPU.cores, "step-40"
        else
          system "make", "run"
        end
      end
    end
    # take step-36 which uses SLEPc
    if build.with? "slepc"
      ohai "running step-36:"
      cp_r prefix/"examples/step-36", testpath
      cd "step-36" do
        system "cmake", "."
        system "make", "release"
        system "make", "run"
      end
    end
    # take step-54 to check opencascade
    if build.with? "opencascade"
      ohai "running step-54:"
      cp_r prefix/"examples/step-54", testpath
      cd "step-54" do
        system "cmake", "."
        system "make", "release"
        system "make", "run"
      end
    end
  end
end
