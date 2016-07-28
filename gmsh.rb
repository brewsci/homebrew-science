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
    sha256 "a3ae14069d89ae8b282da7f22e3b72d151cdf68a5e18b4efedf45a661b04e82f" => :el_capitan
    sha256 "7309b07b2a7642fe8cf6859fa55ba23441096870a0f3b82c34dbd2c002a2ee97" => :yosemite
    sha256 "9c7c1e398f83c3dea045d5288ede8f22e5effe955691f6dc8c426235873e2f1d" => :mavericks
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
