class GmshSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system(*args)
    super *args + ["--username", "gmsh", "--password", "gmsh"]
  end
end

class Gmsh < Formula
  desc "Gmsh is a 3D grid generator with a build-in CAD engine."
  homepage "http://geuz.org/gmsh"
  url "http://geuz.org/gmsh/src/gmsh-2.9.3-source.tgz"
  sha256 "9fc4b376f53c1b84267d0f10896830acb6e41fff393386768169cba3558eb8c6"

  head "https://geuz.org/svn/gmsh/trunk", :using => GmshSvnStrategy

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "09fc0d092facb3c0ef2cd40fdcd5bebc5fc26fddf5759f6e2138988b61a2bc98" => :yosemite
    sha256 "ea8557dfa9e8833ab2ba69fffc5290af352c3f9cd45f289e22731884a3c61c83" => :mavericks
    sha256 "f4a518f7ba84b06fcce16243f3e6dc40b8450116ecab03a7fa0bd44e84b4b4cc" => :mountain_lion
  end

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  depends_on "cmake" => :build
  depends_on "petsc" => :optional
  depends_on "slepc" => :optional
  depends_on "opencascade" => :recommended
  depends_on "fltk" => :optional
  depends_on "cairo" if build.with? "fltk"

  def install
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
