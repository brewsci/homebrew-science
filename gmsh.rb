class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "http://gmsh.info/"
  url "http://gmsh.info/src/gmsh-3.0.3-source.tgz"
  sha256 "4809b4a5c292ff74570b197c0da049aa3af7cd1d5b0950196391b0f20e183fbe"
  head "http://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "49f4ec47754b989676f5ce8709b29c7e2188c206a02922fb333d7793fe1af2f1" => :sierra
    sha256 "9495124ea5ed2191968aec25c56a0494aeebe00422fd5e8d437d17d7d7ab766d" => :el_capitan
    sha256 "1a3bf426b7cb70353f82ea003b0be494a47992e9c75cb1f3338365f8300bc961" => :yosemite
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
  depends_on "openblas" unless OS.mac?

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
