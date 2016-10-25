class Scalapack < Formula
  desc "high-performance linear algebra for distributed memory machines"
  homepage "http://www.netlib.org/scalapack/"
  url "http://www.netlib.org/scalapack/scalapack-2.0.2.tgz"
  sha256 "0c74aeae690fe5ee4db7926f49c5d0bb69ce09eea75beb915e00bba07530395c"
  revision 7

  head "https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk", :using => :svn

  bottle do
    cellar :any
    rebuild 1
    sha256 "dbfbf192acc7257cc71b89a33c7ac12daaa622dd4358a839f331c567af8e205f" => :sierra
    sha256 "db2903d330a92c6e313842f0d9e5dc9d6a502f669a7ed07cbaa6ae083ddb4475" => :el_capitan
    sha256 "a8c8b3f78ca5a211038b9a6a1b8aa4c4fd64e3c2b023ba08036b5e1e82625786" => :yosemite
  end

  option "without-test", "Skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on :mpi => [:cc, :f90]
  depends_on "cmake" => :build
  depends_on "openblas" => OS.mac? ? :optional : :recommended
  depends_on "veclibfort" if build.without?("openblas") && OS.mac?
  depends_on :fortran

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=ON"

    if build.with? "openblas"
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      lapack = blas
    else
      blas = OS.mac? ? "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort" : "-lblas"
      lapack = OS.mac? ? blas : "-llapack"
    end
    args += ["-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{lapack}"]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "install"
      system "make", "test" if build.with? "test"
    end

    pkgshare.install "EXAMPLE"
  end

  test do
    ENV.fortran
    cp_r pkgshare/"EXAMPLE", testpath
    cd "EXAMPLE" do
      system "mpif90", "-o", "xsscaex", "psscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert (`mpirun -np 4 ./xsscaex | grep 'INFO code' | awk '{print $NF}'`.to_i == 0)
      system "mpif90", "-o", "xdscaex", "pdscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert (`mpirun -np 4 ./xdscaex | grep 'INFO code' | awk '{print $NF}'`.to_i == 0)
      system "mpif90", "-o", "xcscaex", "pcscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert (`mpirun -np 4 ./xcscaex | grep 'INFO code' | awk '{print $NF}'`.to_i == 0)
      system "mpif90", "-o", "xzscaex", "pzscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert (`mpirun -np 4 ./xzscaex | grep 'INFO code' | awk '{print $NF}'`.to_i == 0)
    end
  end
end
