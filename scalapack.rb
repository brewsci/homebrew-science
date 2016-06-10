class Scalapack < Formula
  desc "high-performance linear algebra for distributed memory machines"
  homepage "http://www.netlib.org/scalapack/"
  url "http://www.netlib.org/scalapack/scalapack-2.0.2.tgz"
  sha256 "0c74aeae690fe5ee4db7926f49c5d0bb69ce09eea75beb915e00bba07530395c"
  revision 6
  head "https://icl.cs.utk.edu/svn/scalapack-dev/scalapack/trunk", :using => :svn

  bottle do
    cellar :any
    sha256 "fec811b3194d0e5d314dfe07697687cab775f19a4f5ca5a83e541b9d55b9f8de" => :el_capitan
    sha256 "27ecfd322b105fa9244e845906273220919c93fe9e00493e38c3d3c48fac937d" => :yosemite
    sha256 "1176f3a88c9a60b17de132d2d8d576e456d668246615e210e96c1d7b6fc5376b" => :mavericks
  end

  option "without-test", "Skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on :mpi => [:cc, :f90]
  depends_on "cmake" => :build
  depends_on "openblas" => :optional
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
