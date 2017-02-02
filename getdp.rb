class GetdpSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "getdp", "--password", "getdp"]
  end
end

class Getdp < Formula
  desc "Open source finite element solver using mixed elements."
  homepage "http://www.geuz.org/getdp/"
  url "http://getdp.info/src/getdp-2.11.0-source.tgz"
  sha256 "fc3b51e50357466849dbd07656107c8ac9d01c294b04c4801d2c227c1b1273eb"
  revision 1
  head "https://geuz.org/svn/getdp/trunk", :using => GetdpSvnStrategy

  bottle do
    sha256 "670a1e5bbedc2063a03b1934dbe465da8dd6729941e20f3db9e09f5b67f7e45b" => :sierra
    sha256 "341c1d0cd43c6464125c5849f7ee8ee0f078244b1c19476ca0ca831306fe3c7d" => :el_capitan
    sha256 "a26c8c34763b849c4c3b09b04e71c25b0d2122a48f9ec5297d06bb2af8f27281" => :yosemite
  end

  option "without-test", "skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "cmake"    => :build
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  if build.with? "mpi"
    depends_on "arpack"   => [:recommended, "with-mpi"]
  else
    depends_on "arpack" => :recommended
  end
  depends_on "gmsh"     => :recommended
  depends_on "gsl"      => :recommended
  depends_on "hdf5"     => :recommended
  if build.with? "mpi"
    depends_on "hdf5"   => [:recommended, "with-mpi"]
  else
    depends_on "hdf5" => :recommended
  end
  depends_on "metis"    => :recommended
  depends_on "mumps"    => :recommended
  depends_on "petsc"    => :recommended
  depends_on "slepc"    => :recommended

  def install
    args = std_cmake_args
    args << "-DENABLE_BUILD_SHARED=ON"
    args << "-DENABLE_ARPACK=OFF" if build.without? "arpack"
    args << "-DENABLE_GMSH=OFF"   if build.without? "gmsh"
    args << "-DENABLE_GSL=OFF"    if build.without? "gsl"

    if build.with? "petsc"
      ENV["PETSC_DIR"] = Formula["petsc"].opt_prefix
      ENV["PETSC_ARCH"] = "real"
    else
      args << "-DENABLE_PETSC=OFF"
    end

    if build.with? "slepc"
      ENV["SLEPC_DIR"] = "#{Formula["slepc"].opt_prefix}/real"
    else
      args << "-DENABLE_SLEPC=OFF"
    end

    if (build.with? "petsc") || (build.with? "slepc")
      args << "-DENABLE_MPI=ON" if build.with? :mpi
    end

    # Fixed test to work without access to gmsh
    inreplace "CMakeLists.txt", "add_test(${TEST} ${TEST_BIN} ${TEST} - )", "add_test(${TEST} #{bin}/getdp ${TEST})"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
      system "make", "test" if build.with? "check"
    end
  end

  test do
    system "#{bin}/getdp", "#{share}/doc/getdp/demos/magnet.pro"
  end
end
