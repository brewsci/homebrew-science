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
    revision 1
    sha256 "78d4601e03bd39048d9c53b7bb17b022e6864ae8277614fd86d211127c9f4a0a" => :yosemite
    sha256 "f5fe91054fdeddcaa6586cfed6758e1d8c3d4a5f0d5ac76dfd74e9ba5f1070a0" => :mavericks
    sha256 "0e56aac951bcfa25cf667828ef34b60091999750315ac273c1076301ef493c23" => :mountain_lion
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
