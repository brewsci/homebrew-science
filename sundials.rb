class Sundials < Formula
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "http://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz"
  sha256 "d39fcac7175d701398e4eb209f7e92a5b30a78358d4a0c0fcc23db23c11ba104"

  bottle do
    cellar :any
    sha256 "62695e78e1e6fa3b5d9ee3784d32bcd29e961177fe1e5a5b92dee3e6ce9d70e5" => :el_capitan
    sha256 "c405ebe6728d0a3866b92811302825928cff77d3103b58855465774e85749020" => :yosemite
    sha256 "1f2d593b1a1681f4d0f4a9865a90f9a87d61d064288ddb7e9171fd004a81fd2f" => :mavericks
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
