class Sundials < Formula
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "http://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz"
  sha256 "d39fcac7175d701398e4eb209f7e92a5b30a78358d4a0c0fcc23db23c11ba104"

  bottle do
    cellar :any
    sha256 "d693a2b3c7d99c01259597a6eeec921423721e56b0a7cf6f981ea91c8fe39e77" => :sierra
    sha256 "b3f43a32210cda546eecacc659afcd442f43522ad325d75f8e8411beb360babb" => :el_capitan
    sha256 "b68f8366933e83344761b9dacb57a8f1387ad7d2f0856dd24030cfa614b3cf39" => :yosemite
  end

  depends_on :fortran => :optional
  depends_on :mpi => [:cc, :f77, :recommended]

  depends_on "cmake" => :build
  depends_on "openblas" => :optional
  depends_on "petsc" => :optional
  depends_on "veclibfort"

  option "without-check", "Skip build-time checks and examples (not recommended)"

  def install
    args = std_cmake_args
    args << "-DCMAKE_C_COMPILER=clang"
    args << "-DMPI_ENABLE=ON"         if build.with? "mpi"
    args << "-ENABLE_EXAMPLES=OFF"    if build.without? "check"

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
      args << "-DPETSC_LIBRARY_DIR=#{Formula["slepc"].opt_lib}"
      args << "-DPETSC_INCLUDE_DIR=#{Formula["slepc"].opt_inc}"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    test do
      system "cmake", "#{prefix}/examples/arkode/C_serial"
      system "make"
      system "./idaFoodWeb_bnd"
    end
  end

end
