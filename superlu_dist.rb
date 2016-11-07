class SuperluDist < Formula
  desc "Distributed LU factorization for large linear systems"
  homepage "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/"
  url "http://crd-legacy.lbl.gov/~xiaoye/SuperLU/superlu_dist_5.1.0.tar.gz"
  sha256 "30ac554a992441e6041c6fb07772da4fa2fa6b30714279de03573c2cad6e4b60"
  revision 1

  bottle do
    rebuild 1
    sha256 "2c6577bcf69fdc17fce4cd136773a34527f0bbb9f149090c5cfd3cd769b634d4" => :sierra
    sha256 "1a97d5838c71422d1a4545684c1a6e6accf0306924bf32ae7045425cd34d715d" => :el_capitan
    sha256 "82c1a6f39857a82cd568b4d818d2596d4355298fddf61456e24b261eb7717a2f" => :yosemite
  end

  option "without-test", "skip build-time tests (not recommended)"
  option "with-openmp", "Enable OpenMP multithreading"
  needs :openmp if build.with? "openmp"

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :mpi => [:cc, :f77, :f90]

  depends_on "parmetis"
  depends_on "openblas" => OS.mac? ? :optional : :recommended
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?

  def install
    # prevent linking errors on linuxbrew:
    ENV.deparallelize

    dylib_ext = OS.mac? ? "dylib" : "so"

    cmake_args = std_cmake_args
    cmake_args << "-DTPL_PARMETIS_LIBRARIES=#{Formula["parmetis"].opt_lib}/libparmetis.#{dylib_ext};#{Formula["metis"].opt_lib}/libmetis.#{dylib_ext}"
    cmake_args << "-DTPL_PARMETIS_INCLUDE_DIRS=#{Formula["parmetis"].opt_include};#{Formula["metis"].opt_include}"
    cmake_args << "-DCMAKE_C_FLAGS=-fPIC -O2"
    cmake_args << "-DBUILD_SHARED_LIBS=ON"
    cmake_args << "-DCMAKE_C_COMPILER=#{ENV["MPICC"]}"
    cmake_args << "-DCMAKE_Fortran_COMPILER=#{ENV["MPIF90"]}"
    cmake_args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"

    blaslib = ((build.with? "openblas") ? "-L#{Formula["openblas"].opt_lib} -lopenblas" : "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort")
    cmake_args << "-DTPL_BLAS_LIBRARIES=#{blaslib}"

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
      system "make", "test" if build.with? "test"
    end

    doc.install "DOC/ug.pdf"
    pkgshare.install "EXAMPLE"
  end

  test do
    ENV.fortran
    cp pkgshare/"EXAMPLE/dcreate_matrix.c", testpath
    cp pkgshare/"EXAMPLE/pddrive.c", testpath
    cp pkgshare/"EXAMPLE/g20.rua", testpath
    system "mpicc", "-o", "pddrive", "pddrive.c", "dcreate_matrix.c", "-L#{Formula["superlu_dist"].opt_lib}", "-lsuperlu_dist"
    system "mpirun", "-np", "4", "./pddrive", "-r", "2", "-c", "2", "g20.rua"
  end
end
