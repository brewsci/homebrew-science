require 'formula'

class GmshSvnStrategy < SubversionDownloadStrategy
  def quiet_safe_system *args
    super *args + ['--username', 'gmsh', '--password', 'gmsh']
  end
end

class Gmsh < Formula
  homepage 'http://geuz.org/gmsh'
  url 'http://geuz.org/gmsh/src/gmsh-2.8.5-source.tgz'
  sha1 '352671f95816440ddb2099478f3e9f189e40e27a'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "d039d605b267aa6325cbb2b1511d437179c412ef" => :yosemite
    sha1 "684e5d1a9697edfe66e580652394f9230e1e1662" => :mavericks
    sha1 "7d85445c4fdb2c4524c54a222647285090a02e5b" => :mountain_lion
  end

  head 'https://geuz.org/svn/gmsh/trunk', :using => GmshSvnStrategy

  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  depends_on 'cmake' => :build
  depends_on "petsc" => :optional
  depends_on "slepc" => :optional
  depends_on "opencascade" => :recommended
  depends_on 'fltk' => :optional

  def install
    if not build.head? and (build.with? "petsc" or build.with? "slepc")
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
      ENV["SLEPC_DIR"] = "#{Formula['slepc'].opt_prefix}/real"
    else
      args << "-DENABLE_SLEPC=OFF"
    end

    if (build.with? "petsc") or (build.with? "slepc")
      args << "-DENABLE_MPI=ON" if build.with? :mpi
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
