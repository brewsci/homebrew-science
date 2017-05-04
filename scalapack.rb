class Scalapack < Formula
  desc "high-performance linear algebra for distributed memory machines"
  homepage "http://www.netlib.org/scalapack/"
  url "http://www.netlib.org/scalapack/scalapack-2.0.2.tgz"
  sha256 "0c74aeae690fe5ee4db7926f49c5d0bb69ce09eea75beb915e00bba07530395c"
  revision 8

  head "https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk", :using => :svn

  bottle do
    cellar :any
    sha256 "cfa37b8395b4277299ad3dc7ce249e3db8c846f325a48bab381a7f3f4a3c1cc3" => :sierra
    sha256 "90a0d3f4a815f517024e1bece73776ec71cdd8ab694ccc2bd8c62c6be6a00ae0" => :el_capitan
    sha256 "91e417775b352cdbdcd15002ba6f43665874cf7f5925a561150a26b3a276afb8" => :yosemite
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
