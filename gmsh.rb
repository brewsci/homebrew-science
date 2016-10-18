class GmshSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "gmsh", "--password", "gmsh"]
  end
end

class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "http://geuz.org/gmsh"
  url "http://gmsh.info/src/gmsh-2.14.0-source.tgz"
  sha256 "8b344f29ace99167578158fcc4854461630b26808cff9e2dea134ab4267991cd"

  head "https://geuz.org/svn/gmsh/trunk", :using => GmshSvnStrategy

  bottle do
    cellar :any
    sha256 "0d36a78031116182d36f257a07100bef1e7dcafb5c4ec190734b16a845f23341" => :sierra
    sha256 "12e60bf43854d38bdf704529fa716d7b0be8d43d3c508090eb898c96b540a988" => :el_capitan
    sha256 "a34e8f6c644d14759459ebb73bb209acbacfa61757fdc7e6431434e1e1bc660f" => :yosemite
  end

  option "with-oce",               "Build with oce support (conflicts with opencascade)"
  option "with-opencascade",       "Build with opencascade support (conflicts with oce)"

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  depends_on "cmake" => :build

  depends_on "petsc" => :optional
  depends_on "slepc" => :optional
  depends_on "fltk" => :optional
  depends_on "cairo" if build.with? "fltk"


  if build.with?("opencascade") && build.with?("oce")
    odie "gmsh: switches '--with-opencascade' and '--with-oce' are conflicting."
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
