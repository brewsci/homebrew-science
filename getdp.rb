class GetdpSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "getdp", "--password", "getdp"]
  end
end

class Getdp < Formula
  desc "GetDP is an open source finite element solver using mixed elements."
  homepage "http://www.geuz.org/getdp/"
  url "http://www.geuz.org/getdp/src/getdp-2.6.0-source.tgz"
  sha256 "ebbf6791e815dda7a306efbfe3cc0acd30cc2ad9ecf6ac0f2fb9fc75a9aae051"
  head "https://geuz.org/svn/getdp/trunk", :using => GetdpSvnStrategy

  bottle do
    sha256 "dc9d380494af610648a2a75f64c5cec7cd84ca7f451ea3d63bca03aede7c3610" => :yosemite
    sha256 "7551be949972b0b469830c1b874e0f57c6d624cedc67ebe01dac41946a202d5a" => :mavericks
    sha256 "e42699e4804d2b74119ac7af6f8cd4a815432ae0e63e93369152f297f917cf71" => :mountain_lion
  end

  option "without-check", "skip build-time tests (not recommended)"

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  depends_on "arpack" => :recommended
  depends_on "petsc" => :recommended
  depends_on "slepc" => :recommended
  depends_on "gmsh" => :recommended
  depends_on "gsl" => :recommended
  depends_on "cmake" => :build

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
