class GmshSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "gmsh", "--password", "gmsh"]
  end
end

class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "http://geuz.org/gmsh"
  url "http://gmsh.info/src/gmsh-2.13.1-source.tgz"
  sha256 "a10b750aaac7d4ef7d5d168e0be520b0d62ab35380d81bcbb1972db3fb73ac96"

  head "https://geuz.org/svn/gmsh/trunk", :using => GmshSvnStrategy

  bottle do
    cellar :any
    sha256 "bdd427ec111a8a3f29d74fdf9ca3a81bfcd5f90028cead2dadda353454192123" => :el_capitan
    sha256 "cb583113907206bb68478b8a4295380d3265fa71064c93924ae56e7ee3e9aef8" => :yosemite
    sha256 "653d7c82c6ec8767f0e7c1623063f5f518b44477cb006a76ac8a4ff85012d8bc" => :mavericks
  end

  option "with-oce",               "Build with oce support (conflicts with opencascade)"
  option "without-opencascade",    "Build without opencascade support"

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  depends_on "cmake" => :build

  depends_on "petsc" => :optional
  depends_on "slepc" => :optional
  depends_on "fltk" => :optional
  depends_on "cairo" if build.with? "fltk"

  depends_on "cairo" => :linked
  depends_on "fftw" => :linked
  depends_on "gmp" => :linked
  depends_on "jpeg" => :linked
  depends_on "libpng" => :linked
  depends_on "hdf5" => :linked
  depends_on "hwloc" => :linked
  depends_on "metis" => :linked
  depends_on "netcdf" => :linked
  depends_on "parmetis" => :linked
  depends_on "scalapack" => :linked
  depends_on "suite-sparse" => :linked
  depends_on "sundials" => :linked
  depends_on "superlu_dist" => :linked

  if build.with?("opencascade") && build.with?("oce")
    odie "gmsh: --without-opencascade must be specified when using --with-oce"
  else
    depends_on "opencascade"      if build.with? "opencascade"
    depends_on "oce"              if build.with? "oce"
  end

  def install
    # In OS X, gmsh sets default directory locations as if building a
    # binary. These locations must be reset so that they make sense
    # for a Homebrew-based build.
    args = std_cmake_args + ["-DENABLE_OS_SPECIFIC_INSTALL=0",
                             "-DGMSH_BIN=#{bin}",
                             "-DGMSH_LIB=#{lib}",
                             "-DGMSH_DOC=#{pkgshare}/gmsh",
                             "-DGMSH_MAN=#{man}"]

    if build.with? "oce"
      ENV["CASROOT"] = Formula["oce"].opt_prefix
      args << "-DENABLE_OCC=ON"
    elsif build.with? "opencascade"
      ENV["CASROOT"] = Formula["opencascade"].opt_prefix
      args << "-DENABLE_OCC=ON"
    else
      args << "-DENABLE_OCC=OFF"
    end

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
      args << "-DENABLE_MPI=ON" if build.with? "mpi"
    end

    # Make sure native file dialogs are used
    args << "-DENABLE_NATIVE_FILE_CHOOSER=ON"

    # Build a shared library such that others can link
    args << "-DENABLE_BUILD_LIB=ON"
    args << "-DENABLE_BUILD_SHARED=ON"

    # Build with or without GUI
    args << "-DENABLE_FLTK=OFF" if build.without? "fltk"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # move onelab.py into libexec instead of bin
      rm "#{bin}/onelab.py"
      libexec.install "onelab.py"
    end
  end

  def caveats
    "To use onelab.py set your PYTHONDIR to #{libexec}"
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
