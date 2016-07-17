class GetdpSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "getdp", "--password", "getdp"]
  end
end

class Getdp < Formula
  desc "Open source finite element solver using mixed elements."
  homepage "http://www.geuz.org/getdp/"
  url "http://www.geuz.org/getdp/src/getdp-2.9.0-source.tgz"
  sha256 "08487f3f5a41012d06db0ec97206b883961c0e7853f47f8502f6d1ef80ef67c9"
  head "https://geuz.org/svn/getdp/trunk", :using => GetdpSvnStrategy
  revision 2

  bottle do
    sha256 "5f077c6ce12ac1bf40b1a6603f29b20164c25a46fdbaecc8667e00b887dcb76d" => :el_capitan
    sha256 "1e0357c2b6cd4dfa151a395254cce579d12a1013a7af66698f2d5fd24f7819c2" => :yosemite
    sha256 "42633bb91166c5f040e6fbd8447bbda30ce916f845dac2ac6cd329b3a9264e1d" => :mavericks
  end

  option "without-test", "skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  depends_on "arpack"   => :recommended
  depends_on "gmsh"     => :recommended
  depends_on "gsl"      => :recommended
  depends_on "hdf5"     => :recommended
  depends_on "metis"    => :recommended
  depends_on "mumps"    => :recommended
  depends_on "petsc"    => :recommended
  depends_on "slepc"    => :recommended

  depends_on "fftw" => :linked
  depends_on "hwloc" => :linked
  depends_on "netcdf" => :linked
  depends_on "parmetis" => :linked
  depends_on "scalapack" => :linked
  depends_on "suite-sparse" => :linked
  depends_on "sundials" => :linked
  depends_on "superlu_dist" => :linked

  depends_on "cmake"    => :build

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
