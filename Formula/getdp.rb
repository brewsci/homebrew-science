class GetdpSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super(*args + ["--username", "getdp", "--password", "getdp"])
  end
end

class Getdp < Formula
  desc "Open source finite element solver using mixed elements"
  homepage "https://www.geuz.org/getdp/"
  url "https://getdp.info/src/getdp-2.11.1-source.tgz"
  sha256 "bb32d1d24e110eab209e57701d0754289f62402d5ee6672be596310b1a359997"
  revision 3
  head "https://geuz.org/svn/getdp/trunk", using: GetdpSvnStrategy

  option "without-test", "skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "cmake" => :build
  depends_on "gcc" if OS.mac? # for gfortran
  depends_on "gmsh" => :recommended
  depends_on "gsl" => :recommended
  depends_on "hdf5" => :recommended
  depends_on "metis" => :recommended
  depends_on "mumps" => :recommended
  depends_on "open-mpi" => :recommended
  if build.with? "open-mpi"
    depends_on "arpack" => [:recommended, "with-open-mpi"]
  else
    depends_on "arpack" => :recommended
  end
  if build.with? "open-mpi"
    depends_on "hdf5" => [:recommended, "with-open-mpi"]
  else
    depends_on "hdf5" => :recommended
  end
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

    args << "-DENABLE_MPI=ON" if ((build.with? "petsc") || (build.with? "slepc")) && (build.with? :open-mpi)

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
