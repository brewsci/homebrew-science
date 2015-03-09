class Trilinos < Formula
  homepage "http://trilinos.sandia.gov"
  url "http://trilinos.org/oldsite/download/files/trilinos-11.12.1-Source.tar.bz2"
  sha256 "a41539414529c65905260b3befe3aee4f1dd1015ff719f0f6b5a10902d576fda"
  head "https://software.sandia.gov/trilinos/repositories/publicTrilinos", :using => :git

  option "with-teko",  "Enable the Teko secondary-stable package"
  option "with-shylu", "Enable the ShyLU experimental package"
  option "with-check", "Perform build time checks (time consuming and contains failures)"
  option :cxx11

  # options and dependencies not supported in the current version
  # are commented out with #- and failure reasons are documented.

  option "with-cholmod", "Build with Cholmod (Experimental TPL) from suite-sparse"
  #-option "with-csparse", "Build with CSparse (Experimental TPL) from suite-sparse" # Undefined symbols for architecture x86_64: "Amesos_CSparse::Amesos_CSparse(Epetra_LinearProblem const&)"

  depends_on :mpi           => [:cc, :cxx, :recommended]
  depends_on :fortran       => :recommended
  depends_on :x11           => :recommended

  depends_on :python        => :recommended
  depends_on "homebrew/python/numpy"  if build.with? "python"
  depends_on "swig"         => :build if build.with? "python"

  depends_on "cmake"        => :build
  depends_on "pkg-config"   => :build

  depends_on "openblas" => :optional

  depends_on "adol-c"       => :recommended
  depends_on "boost"        => :recommended
  depends_on "cppunit"      => :recommended
  depends_on "doxygen"      => ["with-graphviz", :recommended]
  depends_on "hwloc"        => :recommended
  depends_on "metis"        => :recommended
  depends_on "mumps"        => :recommended
  depends_on "netcdf"       => ["with-fortran", :recommended]
  depends_on "parmetis"     => :recommended if build.with? "mpi"
  depends_on "scalapack"    => :recommended
  depends_on "scotch"       => :recommended
  depends_on "suite-sparse" => :recommended
  depends_on "superlu"      => :recommended
  depends_on "superlu_dist" => :recommended if build.with? "parmetis"

  #-depends_on "petsc"        => :optional # ML packages currently do not compile with PETSc >= 3.3
  #-depends_on "qd"           => :optional # Fails due to global namespace issues (std::pow vs qd::pow)
  #-depends_on "binutils"     => :optional # libiberty is deliberately omitted in Homebrew (see PR #35881)

  # Experimental TPLs:
  #-depends_on "eigen"        => :optional # Intrepid_test_Discretization_Basis_HGRAD_TET_Cn_FEM_ORTH_Test_02 fails to build
  depends_on "hypre"        => [:recommended] + ((build.with? "mpi") ? ["with-mpi"] : []) # EpetraExt tests fail to compile
  depends_on "glpk"         => :recommended
  depends_on "hdf5"         => [:recommended] + ((build.with? "mpi") ? ["with-mpi"] : [])
  depends_on "tbb"          => :recommended
  depends_on "glm"          => :recommended

  #-depends_on "lemon"        => :optional # lemon is currently built as executable only, no libraries
  #-depends_on "cask"         => :optional # cask  is currently built as executable only, no libraries

  # Missing TPLS:
  # YAML, BLACS, Y12M, XDMF, tvmet, thrust, taucs, SPARSEKIT, qpOASES, Portals,
  # Pnetcdf, Peano, PaToH, PAPI, Pablo, Oski, OVIS, OpenNURBS, Nemesis, MF,
  # Matio, MA28, LibTopoMap, InfiniBand, HPCToolkit, HIPS, gtest, gpcd, Gemini,
  # ForUQTK, ExodusII, CUSPARSE, Cusp, CrayPortals, Coupler, Clp, CCOLAMD,
  # BGQPAMI, BGPDCMF, ARPREC, ADIC

  def onoff(s, cond)
    s + ((cond) ? "ON" : "OFF")
  end

  # Patch FindTPLUMFPACK to work with UMFPACK>=5.6.0
  # Amesos to work with Superlu_dist 3.3
  patch :DATA

  def install
    # Trilinos supports only Debug or Release CMAKE_BUILD_TYPE!
    args  = %W[-DCMAKE_INSTALL_PREFIX=#{prefix} -DCMAKE_BUILD_TYPE=Release]
    args += %w[-DBUILD_SHARED_LIBS=ON
               -DTPL_ENABLE_BLAS=ON
               -DTPL_ENABLE_LAPACK=ON
               -DTPL_ENABLE_Zlib:BOOL=ON
               -DTrilinos_ENABLE_ALL_PACKAGES=ON
               -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=ON
               -DTrilinos_ENABLE_TESTS:BOOL=ON
               -DTrilinos_ENABLE_EXAMPLES:BOOL=ON
               -DTrilinos_VERBOSE_CONFIGURE:BOOL=OFF
               -DTrilinos_WARNINGS_AS_ERRORS_FLAGS=""
               -DTrilinos_ENABLE_OpenMP:BOOL=OFF
               -DTPL_ENABLE_Matio=OFF
               -DSacado_ENABLE_TESTS=OFF]

    # constrain Cmake to look for libraries in homebrew's prefix
    args << "-DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}"

    # on Linux Trilinos might pick up wrong MPI.
    # Can't specify "open-mpi" location as other (mpich)
    # implementations may be used.
    args << "-DMPI_BASE_DIR:PATH=#{HOMEBREW_PREFIX}" if build.with? "mpi"

    # BLAS / LAPACK support
    if build.with? "openblas"
      args << "-DBLAS_LIBRARY_NAMES=openblas"
      args << "-DBLAS_LIBRARY_DIRS=#{Formula["openblas"].opt_lib}"
      args << "-DLAPACK_LIBRARY_NAMES=openblas"
      args << "-DLAPACK_LIBRARY_DIRS=#{Formula["openblas"].opt_lib}"
    end

    args << "-DEpetraExt_ENABLE_TESTS=OFF" if build.with? "hypre"

    args << "-DTrilinos_ASSERT_MISSING_PACKAGES=OFF" if build.head?

    args << onoff("-DTPL_ENABLE_MPI:BOOL=",         (build.with? "mpi"))
    args << onoff("-DTrilinos_ENABLE_OpenMP:BOOL=", (ENV.compiler != :clang))
    args << onoff("-DTrilinos_ENABLE_CXX11:BOOL=",  (build.cxx11?))

    # Extra non-default packages
    args << onoff("-DTrilinos_ENABLE_ShyLU:BOOL=",  (build.with? "shylu"))
    args << onoff("-DTrilinos_ENABLE_Teko:BOOL=",   (build.with? "teko"))

    # Third-party libraries
    args << onoff("-DTPL_ENABLE_Boost:BOOL=",       (build.with? "boost"))
    args << onoff("-DTPL_ENABLE_Scotch:BOOL=",      (build.with? "scotch"))
    args << onoff("-DTPL_ENABLE_Netcdf:BOOL=",      (build.with? "netcdf"))
    args << onoff("-DTPL_ENABLE_ADOLC:BOOL=",       (build.with? "adol-c"))
    args << onoff("-DTPL_ENABLE_AMD:BOOL=",         (build.with? "suite-sparse"))

    if (build.with? "suite-sparse") && (build.with? "csparse")
      args << "-DTPL_ENABLE_CSparse:BOOL=ON"
      args << "-DCSparse_LIBRARY_NAMES=cxsparse;amd;colamd;suitesparseconfig"
    else
      args << "-DTPL_ENABLE_CSparse:BOOL=OFF"
    end
    args << onoff("-DTPL_ENABLE_Cholmod:BOOL=",     ((build.with? "suite-sparse") && (build.with? "cholmod")))

    args << onoff("-DTPL_ENABLE_UMFPACK:BOOL=",     (build.with? "suite-sparse"))
    args << "-DUMFPACK_LIBRARY_NAMES=umfpack;amd;colamd;cholmod;suitesparseconfig" if build.with? "suite-sparse"

    args << onoff("-DTPL_ENABLE_CppUnit:BOOL=",     (build.with? "cppunit"))
    args << "-DCppUnit_LIBRARY_DIRS=#{Formula["cppunit"].opt_lib}" if build.with? "cppunit"

    args << onoff("-DTPL_ENABLE_Eigen:BOOL=",       (build.with? "eigen"))
    args << "-DEigen_INCLUDE_DIRS=#{Formula["eigen"].opt_include}/eigen3" if build.with? "eigen"

    args << onoff("-DTPL_ENABLE_GLPK:BOOL=",        (build.with? "glpk"))
    args << onoff("-DTPL_ENABLE_HWLOC:BOOL=",       (build.with? "hwloc"))
    args << onoff("-DTPL_ENABLE_HYPRE:BOOL=",       (build.with? "hypre"))

    # Even though METIS seems to conflicts with ParMETIS in Trilinos config (see TPLsList.cmake in the source folder),
    # we still need to provide METIS_INCLUDE_DIRS so that metis.h is picked up on Linuxbrew.
    if build.with? "metis"
      args << "-DTPL_ENABLE_METIS:BOOL=ON"
      args << "-DMETIS_LIBRARIES=#{Formula["metis"].opt_lib}/libmetis.a"
      args << "-DMETIS_INCLUDE_DIRS=#{Formula["metis"].opt_include}"
    else
      args << "-DTPL_ENABLE_METIS:BOOL=OFF"
    end

    # A hack for mumps 5.0
    # TODO: use extra LIBRARY_NAMES with 5.0 only?
    if build.with? "mumps"
      args << "-DTPL_ENABLE_MUMPS:BOOL=ON"
      args << "-DMUMPS_LIBRARY_DIRS=#{Formula["mumps"].opt_prefix}"
      args << "-DMUMPS_LIBRARY_NAMES=dmumps;pord;mumps_common"
    end

    args << onoff("-DTPL_ENABLE_PETSC:BOOL=",       (build.with? "petsc"))
    args << onoff("-DTPL_ENABLE_HDF5:BOOL=",        (build.with? "hdf5"))

    if build.with? "parmetis"
      # Ensure CMake picks up METIS 5 and not METIS 4.
      args << "-DTPL_ENABLE_ParMETIS:BOOL=ON"
      args << "-DParMETIS_LIBRARIES=#{Formula["parmetis"].opt_lib}/libparmetis.a;#{Formula["metis"].opt_lib}/libmetis.a"
      args << "-DParMETIS_INCLUDE_DIRS=#{Formula["parmetis"].opt_include}"
    else
      args << "-DTPL_ENABLE_ParMETIS:BOOL=OFF"
    end

    args << onoff("-DTPL_ENABLE_SCALAPACK:BOOL=",   (build.with? "scalapack"))

    args << onoff("-DTPL_ENABLE_SuperLU:BOOL=",     (build.with? "superlu"))
    args << "-DSuperLU_INCLUDE_DIRS=#{Formula["superlu"].opt_include}/superlu" if build.with? "superlu"

    args << onoff("-DTPL_ENABLE_SuperLUDist:BOOL=", (build.with? "superlu_dist"))
    args << "-DSuperLUDist_INCLUDE_DIRS=#{Formula["superlu_dist"].opt_include}/superlu_dist" if build.with? "superlu_dist"

    args << onoff("-DTPL_ENABLE_QD:BOOL=",         (build.with? "qd"))
    args << onoff("-DTPL_ENABLE_Lemon:BOOL=",      (build.with? "lemon"))
    args << onoff("-DTPL_ENABLE_GLM:BOOL=",        (build.with? "glm"))
    args << onoff("-DTPL_ENABLE_CASK:BOOL=",       (build.with? "cask"))
    args << onoff("-DTPL_ENABLE_BinUtils:BOOL=",   (build.with? "binutils"))

    args << onoff("-DTPL_ENABLE_TBB:BOOL=",         (build.with? "tbb"))
    args << onoff("-DTPL_ENABLE_X11:BOOL=",         (build.with? "x11"))

    args << onoff("-DTrilinos_ENABLE_Fortran=",     (build.with? "fortran"))
    if build.with? "fortran"
      libgfortran = `$FC --print-file-name libgfortran.a`.chomp
      ENV.append "LDFLAGS", "-L#{File.dirname libgfortran} -lgfortran"
    end

    args << onoff("-DTrilinos_ENABLE_PyTrilinos:BOOL=", (build.with? "python"))
    args << "-DPyTrilinos_INSTALL_PREFIX:PATH=#{prefix}" if build.with? "python"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "VERBOSE=1"
      system ("ctest -j" + Hardware::CPU.cores) if build.with? "check"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/Epetra_BasicPerfTest_test.exe", "16", "12", "1", "1", "25", "-v"
    system "mpirun", "-np", "2", "#{bin}/Epetra_BasicPerfTest_test.exe", "10", "12", "1", "2", "9", "-v" if build.with? "mpi"
    system "#{bin}/Epetra_BasicPerfTest_test_LL.exe", "16", "12", "1", "1", "25", "-v"
    system "mpirun", "-np", "2", "#{bin}/Epetra_BasicPerfTest_test_LL.exe", "10", "12", "1", "2", "9", "-v" if build.with? "mpi"
    # system "#{bin}/Ifpack2_BelosTpetraHybridPlatformExample.exe"                    # this file is not there
    system "#{bin}/KokkosClassic_SerialNodeTestAndTiming.exe"
    #-system "#{bin}/KokkosClassic_TPINodeTestAndTiming.exe"                          # this file is not there
    system "#{bin}/KokkosClassic_TBBNodeTestAndTiming.exe" if build.with? "tbb"
    system "#{bin}/Tpetra_GEMMTiming_TBB.exe" if build.with? "tbb"
    # system "#{bin}/Tpetra_GEMMTiming_TPI.exe"                                       # Fails!!
  end
end

__END__
diff --git a/cmake/TPLs/FindTPLUMFPACK.cmake b/cmake/TPLs/FindTPLUMFPACK.cmake
index e26fc7e..f0b7ab6 100644
--- a/cmake/TPLs/FindTPLUMFPACK.cmake
+++ b/cmake/TPLs/FindTPLUMFPACK.cmake
@@ -55,6 +55,6 @@
 
 
 TRIBITS_TPL_DECLARE_LIBRARIES( UMFPACK
-  REQUIRED_HEADERS umfpack.h amd.h UFconfig.h
+  REQUIRED_HEADERS umfpack.h amd.h SuiteSparse_config.h
   REQUIRED_LIBS_NAMES umfpack amd
   )
diff --git a/packages/amesos/src/Amesos_Superludist.cpp b/packages/amesos/src/Amesos_Superludist.cpp
index 1fcac5d..12036fa 100644
--- a/packages/amesos/src/Amesos_Superludist.cpp
+++ b/packages/amesos/src/Amesos_Superludist.cpp
@@ -473,8 +473,8 @@ int Amesos_Superludist::Factor()
     else                    PrivateSuperluData_->options_.ReplaceTinyPivot = (yes_no_t)NO;
 
     if( IterRefine_ == "NO" ) PrivateSuperluData_->options_.IterRefine = (IterRefine_t)NO;
-    else if( IterRefine_ == "DOUBLE" ) PrivateSuperluData_->options_.IterRefine = DOUBLE;
-    else if( IterRefine_ == "EXTRA" ) PrivateSuperluData_->options_.IterRefine = EXTRA;
+    else if( IterRefine_ == "DOUBLE" ) PrivateSuperluData_->options_.IterRefine = SLU_DOUBLE;
+    else if( IterRefine_ == "EXTRA" ) PrivateSuperluData_->options_.IterRefine = SLU_EXTRA;
 
     //  Without the following two lines, SuperLU_DIST cannot be made
     //  quiet.

