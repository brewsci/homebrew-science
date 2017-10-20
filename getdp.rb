class GetdpSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "getdp", "--password", "getdp"]
  end
end

class Getdp < Formula
  desc "Open source finite element solver using mixed elements."
  homepage "https://www.geuz.org/getdp/"
  url "https://getdp.info/src/getdp-2.11.1-source.tgz"
  sha256 "bb32d1d24e110eab209e57701d0754289f62402d5ee6672be596310b1a359997"
  revision 2
  head "https://geuz.org/svn/getdp/trunk", :using => GetdpSvnStrategy

  bottle do
    sha256 "1e0eb557808e989c9de3bef69ec70d337405b3241345f291809319d41a773be9" => :sierra
    sha256 "98040606b6c9a1f7302f0ca65189ce723a732c5945d39fbb28ab14346ffff650" => :el_capitan
    sha256 "8e50109947e33e0d42dedebf1951a06917b01b887499868d16ba5eb2e1a6f276" => :yosemite
  end

  option "without-test", "skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "cmake" => :build
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  if build.with? "mpi"
    depends_on "arpack" => [:recommended, "with-mpi"]
  else
    depends_on "arpack" => :recommended
  end
  depends_on "gmsh" => :recommended
  depends_on "gsl" => :recommended
  depends_on "hdf5" => :recommended
  if build.with? "mpi"
    depends_on "hdf5" => [:recommended, "with-mpi"]
  else
    depends_on "hdf5" => :recommended
  end
  depends_on "metis" => :recommended
  depends_on "mumps" => :recommended
  depends_on "petsc" => :recommended
  depends_on "slepc" => :recommended

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
