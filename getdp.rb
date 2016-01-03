class GetdpSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "getdp", "--password", "getdp"]
  end
end

class Getdp < Formula
  desc "Open source finite element solver using mixed elements."
  homepage "http://www.geuz.org/getdp/"
  url "http://www.geuz.org/getdp/src/getdp-2.7.0-source.tgz"
  sha256 "122830b700e4535be3ccba025bad5c7702324639a937b5e79fee6a1e92bd34b2"
  head "https://geuz.org/svn/getdp/trunk", :using => GetdpSvnStrategy

  bottle do
    sha256 "f85ee7841765fe4f7c1793433422a600b634882f7ab263ba5507e7ada2a88aa0" => :el_capitan
    sha256 "9e9e0ccfeb81f75e176bbd6b116aa57c83dac8034255d072c5f8d2219fe99074" => :yosemite
    sha256 "add45ad67c6dfb619c140f01ce7f856d9645102840f86f345ecd63e149c277c4" => :mavericks
  end

  option "without-check", "skip build-time tests (not recommended)"

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
