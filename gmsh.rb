class GmshSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "gmsh", "--password", "gmsh"]
  end
end

class Gmsh < Formula
  homepage "http://geuz.org/gmsh"
  url "http://geuz.org/gmsh/src/gmsh-2.9.2-source.tgz"
  sha256 "541cfb469655912380ad3dcc509c0fac5f3efd218c29da0e32c9ffdfc589aa99"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "f07372aebcf35e65f80a9a0998dd80015c77ff267a8a837a33cd41ebf13d9958" => :yosemite
    sha256 "7d909b229d1670ff66baac584e2452b236bef2405f517bd72f6767307f351dac" => :mavericks
    sha256 "6b0e18382376ce0fbc3cedef3e087d116c599b16c7609c2c68c37dc46fcb10a3" => :mountain_lion
  end

  head "https://geuz.org/svn/gmsh/trunk", :using => GmshSvnStrategy

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  depends_on "cmake" => :build
  depends_on "petsc" => :optional
  depends_on "slepc" => :optional
  depends_on "opencascade" => :recommended
  depends_on "fltk" => :optional

  def install
    if !build.head? && ((build.with? "petsc") || (build.with? "slepc"))
      onoe "stable is incompatible with PETSc/SLEPc 3.5.2. Build with --HEAD."
      exit 1
    end

    # In OS X, gmsh sets default directory locations as if building a
    # binary. These locations must be reset so that they make sense
    # for a Homebrew-based build.
    args = std_cmake_args + ["-DENABLE_OS_SPECIFIC_INSTALL=0",
                             "-DGMSH_BIN=#{bin}",
                             "-DGMSH_LIB=#{lib}",
                             "-DGMSH_DOC=#{share}/gmsh",
                             "-DGMSH_MAN=#{man}"]

    if build.with? "opencascade"
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
