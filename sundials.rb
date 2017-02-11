class PETScNoConflictRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("petsc").with?("sundials") }

  def message; <<-EOS.undent
    PETSc must not be compiled with Sundials support to avoid circular dependency:
      brew uninstall petsc
    This formula will build petsc with appropriate options.
    EOS
  end
end

class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "http://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz"
  sha256 "d39fcac7175d701398e4eb209f7e92a5b30a78358d4a0c0fcc23db23c11ba104"
  revision 2

  bottle do
    cellar :any
    sha256 "5c51be519e8750735b2b21edd743d88d1392337ae8e7cdb6e2aeb59ba44cf445" => :sierra
    sha256 "32179d8a0f949ad516e94ae55a0eb01eafe5b7850813a9f1531f177a847c0f84" => :el_capitan
    sha256 "401403d2ba60dc3fdb13db65e2cb374bf8b8c83da839e49fc25c5cd2e6e3acb4" => :yosemite
  end

  option "without-test", "Skip build-time checks and examples (not recommended)"
  deprecated_option "without-check" => "without-test"
  option "with-openmp", "Enable OpenMP multithreading"

  depends_on :fortran => :optional
  depends_on :mpi => [:cc, :f77, :recommended]

  depends_on "cmake"
  depends_on "petsc" => :optional
  depends_on "superlu_mt" => :optional
  depends_on "suite-sparse" => :recommended

  depends_on "openblas" => (OS.mac? ? :optional : :recommended)
  depends_on "veclibfort" if (build.without? "openblas") && OS.mac?

  depends_on PETScNoConflictRequirement if build.with? "petsc"

  needs :openmp if build.with?("openmp") || (build.with?("superlu_mt") && Tab.for_name("superlu_mt").with?("openmp"))

  def install
    args = std_cmake_args
    args << "-DCMAKE_C_COMPILER=#{ENV["CC"]}"
    args << "-DBUILD_SHARED_LIBS=ON"
    args << "-DMPI_ENABLE=ON"         if build.with? "mpi"
    args << "-DOPENMP_ENABLE=ON"      if build.with? "openmp"
    args << "-ENABLE_EXAMPLES=OFF"    if build.without? "test"

    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      lapack = blas
    else
      blas = OS.mac? ? "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort" : "-lblas"
      lapack = OS.mac? ? blas : "-llapack"
    end
    args << "-DLAPACK_ENABLE=ON"
    args << "-DLAPACK_LIBRARIES=#{blas};#{lapack}"

    if build.with? "petsc"
      args << "-DPETSC_ENABLE=ON"
      args << "-DPETSC_LIBRARY_DIR=#{Formula["petsc"].opt_lib}"
      args << "-DPETSC_INCLUDE_DIR=#{Formula["petsc"].opt_include}"
    end

    if build.with? "superlu_mt"
      args << "-DSUPERLUMT_ENABLE=ON"
      args << "-DSUPERLUMT_LIBRARY_DIR=#{Formula["superlu_mt"].opt_lib}"
      args << "-DSUPERLUMT_INCLUDE_DIR=#{Formula["superlu_mt"].opt_include}"
      args << ("-DSUPERLUMT_THREAD_TYPE=" + ((Tab.for_name("superlu_mt").with? "openmp") ? "OpenMP" : "Pthread"))
    end

    if build.with? "suite-sparse"
      args << "-DKLU_ENABLE=ON"
      args << "-DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}"
      args << "-DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "cmake", "#{prefix}/examples/arkode/C_serial"
    system "make", "ark_KrylovDemo_prec"
    system "./ark_KrylovDemo_prec"
  end
end
