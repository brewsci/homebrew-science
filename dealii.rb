class Dealii < Formula
  homepage "http://www.dealii.org"
  url "https://github.com/dealii/dealii/releases/download/v8.2.1/dealii-8.2.1.tar.gz"
  sha256 "d75674e45fe63cd9fa294460fe45228904d51a68f744dbb99cd7b60720f3b2a0"

  head do
    url "https://github.com/dealii/dealii.git"
  end

  option "with-testsuite", "Run full test suite (7000+ tests). Takes a lot of time."

  depends_on "cmake"        => :build
  depends_on :mpi           => [:cc, :cxx, :f90, :recommended]
  depends_on "openblas"     => :optional

  openblasdep = (build.with? "openblas") ? ["with-openblas"] : []
  mpidep      = (build.with? "mpi")      ? ["with-mpi"]      : []

  depends_on "arpack"       => [:recommended] + mpidep + openblasdep
  depends_on "boost"        => :recommended
  depends_on "hdf5"         => [:recommended] + mpidep
  depends_on "metis"        => :recommended
  depends_on "mumps"        => [:recommended] + openblasdep
  depends_on "muparser"     => :recommended
  depends_on "netcdf"       => [:recommended, "with-fortran", "with-cxx-compat"]
  depends_on "opencascade"  => :recommended
  depends_on "petsc"        => [:recommended] + openblasdep
  depends_on "p4est"        => [:recommended] + openblasdep if build.with? "mpi"
  depends_on "slepc"        => :recommended
  # TODO: We won't have bottles if we make Trilinos :recommended because the bot times out.
  depends_on "trilinos"     => [:optional] + openblasdep

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=DebugRelease
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_FIND_FRAMEWORK=LAST
      -Wno-dev
      -DDEAL_II_COMPONENT_COMPAT_FILES=OFF
    ]
    # constrain Cmake to look for libraries in homebrew's prefix
    args << "-DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}"

    if build.with? "openblas"
      ext = OS.mac? ? "dyld" : "so"
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

    args << "-DHDF5_DIR=#{Formula["hdf5"].opt_prefix}" if build.with? "hdf5"
    args << "-DMUMPS_DIR=#{Formula["mumps"].opt_prefix}" if build.with? "mumps"
    args << "-DMETIS_DIR=#{Formula["metis"].opt_prefix}" if build.with? "metis"
    args << "-DARPACK_DIR=#{Formula["arpack"].opt_prefix}" if build.with? "arpack"
    args << "-DP4EST_DIR=#{Formula["p4est"].opt_prefix}" if build.with? "p4est"
    args << "-DOPENCASCADE_DIR=#{Formula["opencascade"].opt_prefix}" if build.with? "opencascade"
    args << "-DNETCDF_DIR=#{Formula["netcdf"].opt_prefix}" if build.with? "netcdf"
    args << "-DPETSC_DIR=#{Formula["petsc"].opt_prefix}" if build.with? "petsc"
    args << "-DSLEPC_DIR=#{Formula["slepc"].opt_prefix}" if build.with? "slepc"
    args << "-DTRILINOS_DIR=#{Formula["trilinos"].opt_prefix}" if build.with? "trilinos"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      # run minimal test cases (8 tests)
      log_name = "make-test.log"
      system "make test 2>&1 | tee #{log_name}"
      ohai `grep "tests passed" "#{log_name}"`.chomp
      prefix.install "#{log_name}"
      # run full test suite if really needed
      if build.with? "testsuite"
        system "make", "setup_tests"
        system "ctest", "-j", Hardware::CPU.cores
      end
      system "make", "install"
    end
  end
end
