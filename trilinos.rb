class Trilinos < Formula
  desc "Algorithms for the solution of large-scale, complex multi-physics engineering and scientific problems"
  homepage "http://trilinos.sandia.gov"
  url "https://trilinos.org/oldsite/download/files/trilinos-12.0.1-Source.tar.bz2"
  sha256 "cab674e88c8ca2d2c54176af60030ed28203c0793f3c64c240363dbe7fa46b99"
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

  openblasdep = (build.with? "openblas") ? ["with-openblas"] : []
  mpidep      = (build.with? "mpi")      ? ["with-mpi"]      : []

  depends_on "adol-c"       => :recommended
  depends_on "boost"        => :recommended
  depends_on "cppunit"      => :recommended
  depends_on "doxygen"      => ["with-graphviz", :recommended]
  depends_on "hwloc"        => :recommended
  depends_on "libmatio"     => [:recommended] + ((build.with? "hdf5") ? ["with-hdf5"] : [])
  depends_on "metis"        => :recommended
  depends_on "mumps"        => [:recommended] + openblasdep
  depends_on "netcdf"       => ["with-fortran", :recommended]
  depends_on "parmetis"     => :recommended if build.with? "mpi"
  depends_on "scalapack"    => [:recommended] + openblasdep
  depends_on "scotch"       => :recommended
  depends_on "suite-sparse" => [:recommended] + openblasdep
  depends_on "superlu"      => [:recommended] + openblasdep
  depends_on "superlu_dist" => [:recommended] + openblasdep if build.with? "parmetis"

  #-depends_on "petsc"        => :optional # ML packages currently do not compile with PETSc >= 3.3
  #-depends_on "qd"           => :optional # Fails due to global namespace issues (std::pow vs qd::pow)
  #-depends_on "binutils"     => :optional # libiberty is deliberately omitted in Homebrew (see PR #35881)

  # Experimental TPLs:
  depends_on "eigen"        => :recommended
  depends_on "hypre"        => [:recommended] + mpidep + openblasdep # EpetraExt tests fail to compile
  depends_on "glpk"         => :recommended
  depends_on "hdf5"         => [:recommended] + mpidep
  depends_on "tbb"          => :recommended
  depends_on "glm"          => :recommended
  depends_on "yaml-cpp"     => :recommended

  #-depends_on "lemon"        => :optional # lemon is currently built as executable only, no libraries
  #-depends_on "cask"         => :optional # cask  is currently built as executable only, no libraries

  # Missing TPLS:
  # BLACS, Y12M, XDMF, tvmet, thrust, taucs, SPARSEKIT, qpOASES, Portals,
  # Pnetcdf, Peano, PaToH, PAPI, Pablo, Oski, OVIS, OpenNURBS, Nemesis, MF,
  # MA28, LibTopoMap, InfiniBand, HPCToolkit, HIPS, gtest, gpcd, Gemini,
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
               -DTrilinos_ENABLE_OpenMP:BOOL=OFF]

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

    args << "-DTrilinos_ASSERT_MISSING_PACKAGES=OFF" if build.head?

    args << onoff("-DTPL_ENABLE_MPI:BOOL=",         (build.with? "mpi"))
    args << onoff("-DTrilinos_ENABLE_OpenMP:BOOL=", (ENV.compiler != :clang))
    args << onoff("-DTrilinos_ENABLE_CXX11:BOOL=",  (build.cxx11?))

    # Extra non-default packages
    args << onoff("-DTrilinos_ENABLE_ShyLU:BOOL=",  (build.with? "shylu"))
    args << onoff("-DTrilinos_ENABLE_Teko:BOOL=",   (build.with? "teko"))

    # Temporary disable due to compiler errors:
    args << "-DTrilinos_ENABLE_STK=OFF"
    args << "-DTrilinos_ENABLE_SEACAS=OFF"
    args << "-DIntrepid_ENABLE_TESTS=OFF"
    args << "-DSacado_ENABLE_TESTS=OFF"
    args << "-DEpetraExt_ENABLE_TESTS=OFF" if build.with? "hypre"
    args << "-DTrilinos_ENABLE_FEI=OFF" unless OS.mac?
    args << "-DTrilinos_ENABLE_Sundance=OFF" if !OS.mac? || MacOS.version < :mavericks

    # Third-party libraries
    args << onoff("-DTPL_ENABLE_Boost:BOOL=",       (build.with? "boost"))
    args << onoff("-DTPL_ENABLE_Scotch:BOOL=",      (build.with? "scotch"))
    args << onoff("-DTPL_ENABLE_Netcdf:BOOL=",      (build.with? "netcdf"))
    args << onoff("-DTPL_ENABLE_ADOLC:BOOL=",       (build.with? "adol-c"))
    args << onoff("-DTPL_ENABLE_AMD:BOOL=",         (build.with? "suite-sparse"))
    args << onoff("-DTPL_ENABLE_Matio:BOOL=",       (build.with? "libmatio"))
    args << onoff("-DTPL_ENABLE_yaml-cpp:BOOL=",    (build.with? "yaml-cpp"))

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
      args << "-DMETIS_LIBRARY_DIRS=#{Formula["metis"].opt_lib}"
      args << "-DMETIS_LIBRARY_NAMES=metis"
      args << "-DTPL_METIS_INCLUDE_DIRS=#{Formula["metis"].opt_include}"
    else
      args << "-DTPL_ENABLE_METIS:BOOL=OFF"
    end

    # A hack for mumps 5.0
    # TODO: use extra LIBRARY_NAMES with 5.0 only?
    if build.with? "mumps"
      args << "-DTPL_ENABLE_MUMPS:BOOL=ON"
      args << "-DMUMPS_LIBRARY_DIRS=#{Formula["mumps"].opt_lib}"
      args << "-DMUMPS_LIBRARY_NAMES=dmumps;pord;mumps_common"
    end

    args << onoff("-DTPL_ENABLE_PETSC:BOOL=",       (build.with? "petsc"))
    args << onoff("-DTPL_ENABLE_HDF5:BOOL=",        (build.with? "hdf5"))

    if build.with? "parmetis"
      # Ensure CMake picks up METIS 5 and not METIS 4.
      args << "-DTPL_ENABLE_ParMETIS:BOOL=ON"
      args << "-DParMETIS_LIBRARY_DIRS=#{Formula["parmetis"].opt_lib};#{Formula["metis"].opt_lib}"
      args << "-DParMETIS_LIBRARY_NAMES=parmetis;metis"
      args << "-DTPL_ParMETIS_INCLUDE_DIRS=#{Formula["parmetis"].opt_include}"
    else
      args << "-DTPL_ENABLE_ParMETIS:BOOL=OFF"
    end

    args << onoff("-DTPL_ENABLE_SCALAPACK:BOOL=",   (build.with? "scalapack"))

    args << onoff("-DTPL_ENABLE_SuperLU:BOOL=",     (build.with? "superlu"))
    args << "-DSuperLU_INCLUDE_DIRS=#{Formula["superlu"].opt_include}/superlu" if build.with? "superlu"

    # fix for 4.0:
    args << "-DHAVE_SUPERLUDIST_LUSTRUCTINIT_2ARG:BOOL=ON" if build.with? "superlu_dist"
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

  def caveats; <<-EOS
    On Linuxbrew install with:
      --with-openblas --without-scotch
    EOS
  end

  test do
    system "#{bin}/Epetra_BasicPerfTest_test.exe", "16", "12", "1", "1", "25", "-v"
    system "mpirun", "-np", "2", "#{bin}/Epetra_BasicPerfTest_test.exe", "10", "12", "1", "2", "9", "-v" if build.with? "mpi"
    system "#{bin}/Epetra_BasicPerfTest_test_LL.exe", "16", "12", "1", "1", "25", "-v"
    system "mpirun", "-np", "2", "#{bin}/Epetra_BasicPerfTest_test_LL.exe", "10", "12", "1", "2", "9", "-v" if build.with? "mpi"
    # system "#{bin}/Ifpack2_BelosTpetraHybridPlatformExample.exe"                    # this file is not there
    # system "#{bin}/KokkosClassic_SerialNodeTestAndTiming.exe"                       # this file is not there
    # system "#{bin}/KokkosClassic_TPINodeTestAndTiming.exe"                          # this file is not there
    # system "#{bin}/KokkosClassic_TBBNodeTestAndTiming.exe" if build.with? "tbb"     # this file is not there
    # system "#{bin}/Tpetra_GEMMTiming_TBB.exe" if build.with? "tbb"                  # this file is not there
    # system "#{bin}/Tpetra_GEMMTiming_TPI.exe"                                       # this file is not there
  end
end

__END__
diff --git a/cmake/TPLs/FindTPLUMFPACK.cmake b/cmake/TPLs/FindTPLUMFPACK.cmake
index 963eb71..998cd02 100644
--- a/cmake/TPLs/FindTPLUMFPACK.cmake
+++ b/cmake/TPLs/FindTPLUMFPACK.cmake
@@ -55,6 +55,6 @@
 
 
 TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES( UMFPACK
-  REQUIRED_HEADERS umfpack.h amd.h UFconfig.h
+  REQUIRED_HEADERS umfpack.h amd.h SuiteSparse_config.h
   REQUIRED_LIBS_NAMES umfpack amd
   )
diff --git a/packages/rol/test/vector/test_03.cpp b/packages/rol/test/vector/test_03.cpp
index 5722915..fa53818 100644
--- a/packages/rol/test/vector/test_03.cpp
+++ b/packages/rol/test/vector/test_03.cpp
@@ -75,8 +75,8 @@ int main(int argc, char *argv[]) {
 	RCP<Vector<RealT> > y = rcp(new StdVector<RealT>(y_rcp)); 
 	RCP<Vector<RealT> > z = rcp(new StdVector<RealT>(z_rcp)); 
 
-	ArrayRCP<RCP<Vector<RealT>>> A_rcp(2);
-	ArrayRCP<RCP<Vector<RealT>>> B_rcp(2);
+	ArrayRCP<RCP<Vector<RealT> > > A_rcp(2);
+	ArrayRCP<RCP<Vector<RealT> > > B_rcp(2);
 
 	A_rcp[0] = x;     
 	A_rcp[1] = y;     
@@ -84,8 +84,8 @@ int main(int argc, char *argv[]) {
 	B_rcp[0] = w;     
 	B_rcp[1] = z;     
 
-	RCP<MultiVector<RealT>> A = rcp(new MultiVectorDefault<RealT>(A_rcp));
-	RCP<MultiVector<RealT>> B = rcp(new MultiVectorDefault<RealT>(B_rcp));
+	RCP<MultiVector<RealT> > A = rcp(new MultiVectorDefault<RealT>(A_rcp));
+	RCP<MultiVector<RealT> > B = rcp(new MultiVectorDefault<RealT>(B_rcp));
        
 	// Test norm
 	if(static_cast<int>(norm_sum(*A)) != 6) {
@@ -93,13 +93,13 @@ int main(int argc, char *argv[]) {
 	}
 
 	// Test clone
-	RCP<MultiVector<RealT>> C = A->clone();    
+	RCP<MultiVector<RealT> > C = A->clone();    
 	if(norm_sum(*C) != 0) {
 	    ++errorFlag;
 	}
 
 	// Test deep copy
-        RCP<MultiVector<RealT>> D = A->deepCopy();
+        RCP<MultiVector<RealT> > D = A->deepCopy();
 	if(static_cast<int>(norm_sum(*D)) != 6) {
 	    ++errorFlag;
 	}
@@ -108,7 +108,7 @@ int main(int argc, char *argv[]) {
 	std::vector<int> index(1);
 	index[0] = 0;
 
-        RCP<MultiVector<RealT>> S = A->shallowCopy(index);
+        RCP<MultiVector<RealT> > S = A->shallowCopy(index);
 	if(static_cast<int>(norm_sum(*S)) != 1) {
 	    ++errorFlag;
 	}
diff --git a/packages/didasko/examples/hypre/hypre_Helpers.hpp b/packages/didasko/examples/hypre/hypre_Helpers.hpp
index 930719e..70ac59f 100644
--- a/packages/didasko/examples/hypre/hypre_Helpers.hpp
+++ b/packages/didasko/examples/hypre/hypre_Helpers.hpp
@@ -51,11 +51,11 @@
 
 #include <string>
 
-EpetraExt_HypreIJMatrix::EpetraExt_HypreIJMatrix* newHypreMatrix(int N);
+EpetraExt_HypreIJMatrix* newHypreMatrix(int N);
 
-Epetra_CrsMatrix::Epetra_CrsMatrix* newCrsMatrix(int N);
+Epetra_CrsMatrix* newCrsMatrix(int N);
 
-Epetra_CrsMatrix::Epetra_CrsMatrix* GetCrsMatrix(EpetraExt_HypreIJMatrix &Matrix);
+Epetra_CrsMatrix* GetCrsMatrix(EpetraExt_HypreIJMatrix &Matrix);
 
 bool EquivalentVectors(Epetra_MultiVector &X, Epetra_MultiVector &Y, double tol);

diff --git a/packages/didasko/examples/hypre/hypre_Helpers.cpp b/packages/didasko/examples/hypre/hypre_Helpers.cpp
index 1bf1b2c..793e218 100644
--- a/packages/didasko/examples/hypre/hypre_Helpers.cpp
+++ b/packages/didasko/examples/hypre/hypre_Helpers.cpp
@@ -60,7 +60,7 @@
 
 using Teuchos::RCP;
 using Teuchos::rcp;
-EpetraExt_HypreIJMatrix::EpetraExt_HypreIJMatrix* newHypreMatrix(const int N)
+EpetraExt_HypreIJMatrix* newHypreMatrix(const int N)
 {
   HYPRE_IJMatrix Matrix;
   int ierr = 0;
@@ -117,7 +117,7 @@ EpetraExt_HypreIJMatrix::EpetraExt_HypreIJMatrix* newHypreMatrix(const int N)
   return RetMat;
 }
 
-Epetra_CrsMatrix::Epetra_CrsMatrix* newCrsMatrix(int N){
+Epetra_CrsMatrix* newCrsMatrix(int N){
 
   Epetra_MpiComm Comm(MPI_COMM_WORLD);
 
@@ -138,7 +138,7 @@ Epetra_CrsMatrix::Epetra_CrsMatrix* newCrsMatrix(int N){
   return Matrix;
 }
 
-Epetra_CrsMatrix::Epetra_CrsMatrix* GetCrsMatrix(EpetraExt_HypreIJMatrix *Matrix)
+Epetra_CrsMatrix* GetCrsMatrix(EpetraExt_HypreIJMatrix *Matrix)
 {
   int N = Matrix->NumGlobalRows();
   Epetra_CrsMatrix* TestMat = new Epetra_CrsMatrix(Copy, Matrix->RowMatrixRowMap(), Matrix->RowMatrixColMap(), N, false);
