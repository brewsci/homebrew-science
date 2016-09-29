class Nest < Formula
  desc "The Neural Simulation Tool"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/releases/download/v2.10.0/nest-2.10.0.tar.gz"
  sha256 "2b6fc562cd6362e812d94bb742562a5a685fb1c7e08403765dbe123d59b0996c"
  revision 3

  head "https://github.com/nest/nest-simulator.git"

  bottle do
    sha256 "1d445257846c9b46d8bbc18fd78a397323ec5666bb27e0e9769ef33a01f6effc" => :sierra
    sha256 "a11d6081904bf50de77b184b9146257c472b266da6b5ea4f05a70ddcd68fd5a7" => :el_capitan
    sha256 "b477d20586f143fd4cc7967c1006670b9aac9edbc96c13b9653fc4342e76535f" => :yosemite
  end

  stable do
    # Fix stable build with GCC 6
    # https://github.com/nest/nest-simulator/pull/389
    patch :DATA
  end

  option "with-python", "Build Python bindings (PyNEST)."
  option "without-openmp", "Build without OpenMP support."
  needs :openmp if build.with? "openmp"

  depends_on "gsl" => :recommended
  depends_on :mpi => [:optional, :cc, :cxx]
  depends_on :python => :optional if MacOS.version <= :snow_leopard
  depends_on "numpy" => :python if build.with? "python"
  depends_on "scipy" => :python if build.with? "python"
  depends_on "matplotlib" => :python if build.with? "python"
  depends_on "cython" => :python if build.with? "python"
  depends_on "nose" => :python if build.with? "python"
  depends_on "libtool" => :run
  depends_on "readline" => :run
  depends_on "autoconf" => :build unless build.head?
  depends_on "automake" => :build unless build.head?
  depends_on "cmake" => :build if build.head?

  fails_with :clang do
    cause <<-EOS.undent
      Building NEST with clang is not stable. See https://github.com/nest/nest-simulator/issues/74 .
    EOS
  end

  env :std

  def install
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")

    if build.head?
      args = ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]

      args << "-Dwith-mpi=ON" if build.with? "mpi"
      args << "-Dwith-openmp=OFF" if build.without? "openmp"
      args << "-Dwith-gsl=OFF" if build.without? "gsl"
      args << "-Dwith-python=OFF" if build.without? "python"

      # "out of source" build
      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
      return
    end

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
           ]

    if build.with? "mpi"
      # change CC / CXX in open-mpi
      ENV["OMPI_CC"] = ENV["CC"]
      ENV["OMPI_CXX"] = ENV["CXX"]

      # change CC / CXX in mpich
      ENV["MPICH_CC"] = ENV["CC"]
      ENV["MPICH_CXX"] = ENV["CXX"]

      args << "CC=#{ENV["MPICC"]}"
      args << "CXX=#{ENV["MPICXX"]}"
      args << "--with-mpi"
    end

    args << "--without-openmp" if build.without? "openmp"
    args << "--without-gsl" if build.without? "gsl"
    args << "--without-python" if build.without? "python"

    # "out of source" build
    mkdir "build" do
      system "../configure", *args
      # adjust src and bld path
      inreplace "../sli/slistartup.cc", /PKGSOURCEDIR/, "\"#{pkgshare}/sources\""
      inreplace "libnestutil/sliconfig.h", /#define SLI_BUILDDIR .*/, "#define SLI_BUILDDIR \"#{pkgshare}/sources/build\""
      # do not re-generate .hlp during /validate (tries to regenerate from
      # not existing source file)
      inreplace "../lib/sli/helpinit.sli", /^ makehelp$/, "% makehelp"
      system "make"
      system "make", "install"
    end

    # install sources for later testing
    mkdir pkgshare/"sources"
    (pkgshare/"sources").install Dir["./*"]
  end

  test do
    # simple check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # necessary for the python tests
    ENV["exec_prefix"] = prefix
    # if build.head? does not seem to work
    if !File.directory?(pkgshare/"sources")
      # Skip tests for correct copyright headers
      ENV["NEST_SOURCE"] = "SKIP"
    else
      # necessary for one regression on the sources
      ENV["NEST_SOURCE"] = pkgshare/"sources"
    end

    if build.with? "mpi"
      # we need the command /mpirun defined for the mpi tests
      # and since we are in the sandbox, we create it again
      nestrc = %{
        /mpirun
        [/integertype /stringtype]
        [/numproc     /slifile]
        {
         () [
          (mpirun -np ) numproc cvs ( ) statusdict/prefix :: (/bin/nest )  slifile
         ] {join} Fold
        } Function def
      }
      File.open(ENV["HOME"]+"/.nestrc", "w") { |file| file.write(nestrc) }
    end

    # run all tests
    args = []
    args << "--test-pynest" if build.with? "python"
    system pkgshare/"extras/do_tests.sh", *args
  end
end
__END__
diff --git a/sli/slistartup.cc b/sli/slistartup.cc
index f485c5c..28174ef 100644
--- a/sli/slistartup.cc
+++ b/sli/slistartup.cc
@@ -65,14 +65,17 @@ SLIStartup::checkpath( std::string const& path, std::string& result ) const
   const std::string fullname = fullpath + "/" + startupfilename;

   std::ifstream in( fullname.c_str() );
-  if ( in )
+
+  if ( in.good() )
   {
     result = fullname;
+    return true;
   }
   else
+  {
     result.erase();
-
-  return ( in );
+    return false;
+  }
 }
