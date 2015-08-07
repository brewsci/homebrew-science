class Trilinos < Formula
  desc "Algorithms for the solution of large-scale, complex multi-physics engineering and scientific problems"
  homepage "http://trilinos.sandia.gov"
  url "https://trilinos.org/oldsite/download/files/trilinos-12.2.1-Source.tar.bz2"
  sha256 "4a884fd5eef885815d25fc24c5a4b95e5e67b9eefaa01d61524eef92ae9319fd"
  head "https://software.sandia.gov/trilinos/repositories/publicTrilinos", :using => :git

  bottle do
    sha256 "083648d9cc7a22bbc5ccdf822653a30b7cdca3fca1a939bf805521c6b50bfc58" => :yosemite
    sha256 "2d25fadc5ed69495dff755f09d221d74c3f848b902f0d28e1c0c7686c1f8d16d" => :mavericks
    sha256 "c3228337baae9844b2f471499bf4289912be5536bfb4644fc857a0e57840810e" => :mountain_lion
  end

  option "with-check", "Perform build time checks (time consuming and contains failures)"

  # options and dependencies not supported in the current version
  # are commented out with #- and failure reasons are documented.

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
  #-depends_on "superlu"      => [:recommended] + openblasdep // Amesos2_Superlu_FunctionMap.hpp:83:14: error: no type named 'superlu_options_t' in namespace 'SLU'
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
  # Teuchos_Details_Allocator to have max_size()
  # and other minor compiler errors
  patch :DATA

  # Kokkos, Tpetra and Sacado will be OFF without cxx11
  needs :cxx11
  def install
    ENV.cxx11
    # Trilinos supports only Debug or Release CMAKE_BUILD_TYPE!
    args  = %W[-DCMAKE_INSTALL_PREFIX=#{prefix} -DCMAKE_BUILD_TYPE=Release]
    args += %w[-DBUILD_SHARED_LIBS=ON
               -DTPL_ENABLE_BLAS=ON
               -DTPL_ENABLE_LAPACK=ON
               -DTPL_ENABLE_Zlib:BOOL=ON
               -DTrilinos_ENABLE_ALL_PACKAGES=ON
               -DTrilinos_ENABLE_ALL_OPTIONAL_PACKAGES=ON
               -DTrilinos_ENABLE_EXAMPLES:BOOL=ON
               -DTrilinos_VERBOSE_CONFIGURE:BOOL=OFF
               -DTrilinos_WARNINGS_AS_ERRORS_FLAGS=""]

    # enable tests only when we inted to run checks.
    # that reduced the build time from 130 min to 51 min.
    args << onoff("-DTrilinos_ENABLE_TESTS:BOOL=",  (build.with? "check"))
    # some tests are needed to have binaries in the "test do" block:
    args << "-DEpetra_ENABLE_TESTS=ON"

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
    args << "-DTrilinos_ENABLE_CXX11:BOOL=ON"

    # Extra non-default packages
    args << "-DTrilinos_ENABLE_ShyLU:BOOL=ON"
    args << "-DTrilinos_ENABLE_Teko:BOOL=ON"

    # Temporary disable due to compiler errors:
    # packages:
    args << "-DTrilinos_ENABLE_FEI=OFF"
    args << "-DTrilinos_ENABLE_Piro=OFF"
    args << "-DTrilinos_ENABLE_SEACAS=OFF"
    args << "-DTrilinos_ENABLE_STK=OFF"
    args << "-DTrilinos_ENABLE_Stokhos=OFF"
    args << "-DTrilinos_ENABLE_Sundance=OFF" if !OS.mac? || MacOS.version < :mavericks
    # Amesos, conflicting types of double and complex SLU_D
    # see https://trilinos.org/pipermail/trilinos-users/2015-March/004731.html
    # and https://trilinos.org/pipermail/trilinos-users/2015-March/004802.html
    if build.with? "superlu_dist"
      args << "-DTeuchos_ENABLE_COMPLEX:BOOL=OFF"
      args << "-DKokkosTSQR_ENABLE_Complex:BOOL=OFF"
    end
    # tests:
    args << "-DIntrepid_ENABLE_TESTS=OFF"
    args << "-DSacado_ENABLE_TESTS=OFF"
    args << "-DEpetraExt_ENABLE_TESTS=OFF" if build.with? "hypre"
    args << "-DMesquite_ENABLE_TESTS=OFF"
    args << "-DIfpack2_ENABLE_TESTS=OFF"

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
    args << onoff("-DTPL_ENABLE_Cholmod:BOOL=",     (build.with? "suite-sparse"))

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
      # When trilinos is built with Python, libpytrilinos is included through
      # cmake configure files. Namely, Trilinos_LIBRARIES in TrilinosConfig.cmake
      # contains pytrilinos. This leads to a run-time error:
      # Symbol not found: _PyBool_Type
      # and prevents Trilinos to be used in any C++ code, which links executable
      # against the libraries listed in Trilinos_LIBRARIES.
      # See https://github.com/Homebrew/homebrew-science/issues/2148#issuecomment-103614509
      # A workaround it to remove PyTrilinos from the COMPONENTS_LIST :
      inreplace "#{lib}/cmake/Trilinos/TrilinosConfig.cmake" do |s|
        s.gsub! "PyTrilinos;", "" if s.include? "COMPONENTS_LIST"
      end
    end
  end

  def caveats; <<-EOS
    The following Trilinos packages were disabled due to compile errors:
      FEI, Piro, SEACAS, STK, Stokhos

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
diff --git a/packages/teuchos/core/src/Teuchos_Details_Allocator.hpp b/packages/teuchos/core/src/Teuchos_Details_Allocator.hpp
index fc4c408..d44af4c 100644
--- a/packages/teuchos/core/src/Teuchos_Details_Allocator.hpp
+++ b/packages/teuchos/core/src/Teuchos_Details_Allocator.hpp
@@ -282,6 +282,11 @@ public:
   ///   the rebind struct is required.
   template<class U>
   struct rebind { typedef Allocator<U> other; };
+
+  size_type max_size() const
+  {
+     return std::numeric_limits<size_type>::max();
+  }
 
   /// \brief Allocate an array of n instances of value_type.
   ///
diff --git a/packages/pike/blackbox/src/Pike_BlackBoxModelEvaluator_SolverAdapter.cpp b/packages/pike/blackbox/src/Pike_BlackBoxModelEvaluator_SolverAdapter.cpp
index 799ff9b..081182f 100644
--- a/packages/pike/blackbox/src/Pike_BlackBoxModelEvaluator_SolverAdapter.cpp
+++ b/packages/pike/blackbox/src/Pike_BlackBoxModelEvaluator_SolverAdapter.cpp
@@ -35,7 +35,7 @@ namespace pike {
	  // a new parameter
	  parameterNameToIndex_[models[m]->getParameterName(p)] = parameterNames_.size();
	  parameterNames_.push_back(models[m]->getParameterName(p));
-	  std::vector<std::pair<int,int>> tmp;
+	  std::vector<std::pair<int,int> > tmp;
	  tmp.push_back(std::make_pair(m,p));
	  parameterIndexToModelIndices_.push_back(tmp);
 	}
@@ -120,7 +120,7 @@ namespace pike {
     TEUCHOS_ASSERT(l >= 0);
     TEUCHOS_ASSERT(l < static_cast<int>(parameterNames_.size()));

-    const std::vector<std::pair<int,int>>& meToSet = parameterIndexToModelIndices_[l];
+    const std::vector<std::pair<int,int> >& meToSet = parameterIndexToModelIndices_[l];
 
     // Not ideal.  const_cast or friend class with nonconst private
     // accessor or put public nonconst accessor on solver base.  None

diff --git a/packages/ifpack/src/Ifpack_Hypre.cpp b/packages/ifpack/src/Ifpack_Hypre.cpp
index ea6ba35..1a152ad 100644
--- a/packages/ifpack/src/Ifpack_Hypre.cpp
+++ b/packages/ifpack/src/Ifpack_Hypre.cpp
@@ -401,35 +401,35 @@ int Ifpack_Hypre::Multiply(bool TransA, const Epetra_MultiVector& X, Epetra_Mult
 //==============================================================================
 std::ostream& Ifpack_Hypre::Print(std::ostream& os) const{
   if (!Comm().MyPID()) {
-    os << endl;
-    os << "================================================================================" << endl;
-    os << "Ifpack_Hypre: " << Label () << endl << endl;
-    os << "Using " << Comm().NumProc() << " processors." << endl;
-    os << "Global number of rows            = " << A_->NumGlobalRows() << endl;
-    os << "Global number of nonzeros        = " << A_->NumGlobalNonzeros() << endl;
-    os << "Condition number estimate = " << Condest() << endl;
-    os << endl;
-    os << "Phase           # calls   Total Time (s)       Total MFlops     MFlops/s" << endl;
-    os << "-----           -------   --------------       ------------     --------" << endl;
+    os << std::endl;
+    os << "================================================================================" << std::endl;
+    os << "Ifpack_Hypre: " << Label () << std::endl << std::endl;
+    os << "Using " << Comm().NumProc() << " processors." << std::endl;
+    os << "Global number of rows            = " << A_->NumGlobalRows() << std::endl;
+    os << "Global number of nonzeros        = " << A_->NumGlobalNonzeros() << std::endl;
+    os << "Condition number estimate = " << Condest() << std::endl;
+    os << std::endl;
+    os << "Phase           # calls   Total Time (s)       Total MFlops     MFlops/s" << std::endl;
+    os << "-----           -------   --------------       ------------     --------" << std::endl;
     os << "Initialize()    "   << std::setw(5) << NumInitialize_
        << "  " << std::setw(15) << InitializeTime_
-       << "              0.0              0.0" << endl;
+       << "              0.0              0.0" << std::endl;
     os << "Compute()       "   << std::setw(5) << NumCompute_
        << "  " << std::setw(15) << ComputeTime_
        << "  " << std::setw(15) << 1.0e-6 * ComputeFlops_;
     if (ComputeTime_ != 0.0)
-      os << "  " << std::setw(15) << 1.0e-6 * ComputeFlops_ / ComputeTime_ << endl;
+      os << "  " << std::setw(15) << 1.0e-6 * ComputeFlops_ / ComputeTime_ << std::endl;
     else
-      os << "  " << std::setw(15) << 0.0 << endl;
+      os << "  " << std::setw(15) << 0.0 << std::endl;
     os << "ApplyInverse()  "   << std::setw(5) << NumApplyInverse_
        << "  " << std::setw(15) << ApplyInverseTime_
        << "  " << std::setw(15) << 1.0e-6 * ApplyInverseFlops_;
     if (ApplyInverseTime_ != 0.0)
-      os << "  " << std::setw(15) << 1.0e-6 * ApplyInverseFlops_ / ApplyInverseTime_ << endl;
+      os << "  " << std::setw(15) << 1.0e-6 * ApplyInverseFlops_ / ApplyInverseTime_ << std::endl;
     else
-      os << "  " << std::setw(15) << 0.0 << endl;
-    os << "================================================================================" << endl;
-    os << endl;
+      os << "  " << std::setw(15) << 0.0 << std::endl;
+    os << "================================================================================" << std::endl;
+    os << std::endl;
   }
   return os;
 } //Print()
diff --git a/packages/pike/blackbox/test/core/rxn.cpp b/packages/pike/blackbox/test/core/rxn.cpp
index ac37aa3..17bd540 100644
--- a/packages/pike/blackbox/test/core/rxn.cpp
+++ b/packages/pike/blackbox/test/core/rxn.cpp
@@ -36,13 +36,13 @@ namespace pike_test {
      This will demonstrate order of accuracy for split system.
   */
 
-  double evaluateOrder(const std::vector<std::pair<double,double>>& error);
+  double evaluateOrder(const std::vector<std::pair<double,double> >& error);
 
   void runTransientSolve(const double& startTime,
			 const double& endTime,
			 const double& stepSize,
			 RxnAll& rxnME,
-			 std::vector<std::pair<double,double>>& error);
+			 std::vector<std::pair<double,double> >& error);
 
   void runTransientSolveSingleME(const double& startTime,
				 const double& endTime,
@@ -51,7 +51,7 @@ namespace pike_test {
				 pike_test::RxnSingleEq1& rxnME1,
				 pike_test::RxnSingleEq2& rxnME2,
				 pike_test::RxnSingleEq3& rxnME3,
-				 std::vector<std::pair<double,double>>& error);
+				 std::vector<std::pair<double,double> >& error);
 
   TEUCHOS_UNIT_TEST(rxn, monolithic)
   {
@@ -69,7 +69,7 @@ namespace pike_test {
     const double startTime = 0.0;
     const double endTime = 0.1;
 
-    std::vector<std::pair<double,double>> error;
+    std::vector<std::pair<double,double> > error;
     runTransientSolve(startTime,endTime,1e-1,*rxnME,error);
     runTransientSolve(startTime,endTime,5e-2,*rxnME,error);
     runTransientSolve(startTime,endTime,1e-2,*rxnME,error);
@@ -133,7 +133,7 @@ namespace pike_test {
     const double startTime = 0.0;
     const double endTime = 0.1;
 
-    std::vector<std::pair<double,double>> error;
+    std::vector<std::pair<double,double> > error;
     runTransientSolveSingleME(startTime,endTime,1e-1,*rxnME,*rxnME1,*rxnME2,*rxnME3,error);
     runTransientSolveSingleME(startTime,endTime,5e-2,*rxnME,*rxnME1,*rxnME2,*rxnME3,error);
     runTransientSolveSingleME(startTime,endTime,1e-2,*rxnME,*rxnME1,*rxnME2,*rxnME3,error);
@@ -150,7 +150,7 @@ namespace pike_test {
     TEST_ASSERT( std::abs(order-4.0) < 1.0e-1);
   }
 
-  double evaluateOrder(const std::vector<std::pair<double,double>>& error)
+  double evaluateOrder(const std::vector<std::pair<double,double> >& error)
   {
     const std::size_t size = error.size();
     std::vector<double> log_x(size);
@@ -199,7 +199,7 @@ namespace pike_test {
			 const double& endTime,
			 const double& stepSize,
			 RxnAll& rxnME,
-			 std::vector<std::pair<double,double>>& error)
+			 std::vector<std::pair<double,double> >& error)
   {
     int numSteps = (endTime - startTime) / stepSize;
     TEUCHOS_ASSERT(std::fabs(numSteps*stepSize - (endTime-startTime) ) < 1.0e-10);
@@ -219,7 +219,7 @@ namespace pike_test {
				 pike_test::RxnSingleEq1& rxnME1,
				 pike_test::RxnSingleEq2& rxnME2,
				 pike_test::RxnSingleEq3& rxnME3,
-				 std::vector<std::pair<double,double>>& error)
+				 std::vector<std::pair<double,double> >& error)
   {
     int numSteps = (endTime - startTime) / stepSize;
     TEUCHOS_ASSERT(std::fabs(numSteps*stepSize - (endTime-startTime) ) < 1.0e-10);
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

diff --git a/packages/muelu/adapters/CMakeLists.txt b/packages/muelu/adapters/CMakeLists.txt
index 0e6810b..dbd3756 100644
--- a/packages/muelu/adapters/CMakeLists.txt
+++ b/packages/muelu/adapters/CMakeLists.txt
@@ -125,7 +125,7 @@ TRIBITS_ADD_LIBRARY(
   muelu-adapters
   HEADERS ${HEADERS}
   SOURCES ${SOURCES}
-#  DEPLIBS muelu muelu-interface
+  DEPLIBS muelu muelu-interface
   ADDED_LIB_TARGET_NAME_OUT MUELU_ADAPTERS_LIBNAME
   )

diff --git a/packages/muelu/src/Interface/CMakeLists.txt b/packages/muelu/src/Interface/CMakeLists.txt
index 5ea6083..db93429 100644
--- a/packages/muelu/src/Interface/CMakeLists.txt
+++ b/packages/muelu/src/Interface/CMakeLists.txt
@@ -86,6 +86,7 @@ TRIBITS_ADD_LIBRARY(
   muelu-interface
   HEADERS ${HEADERS}
   SOURCES ${SOURCES}
+  DEPLIBS muelu
   )

 # for debugging

diff --git a/packages/mesquite/CMakeLists.txt b/packages/mesquite/CMakeLists.txt
index 7cbf084..3865e24 100644
--- a/packages/mesquite/CMakeLists.txt
+++ b/packages/mesquite/CMakeLists.txt
@@ -25,7 +25,7 @@ ELSE()
   #

   TRIBITS_PACKAGE(Mesquite DISABLE_STRONG_WARNINGS)
-  SET( ${PACKAGE_NAME}_ENABLE_TESTS ${Trilinos_ENABLE_TESTS} )
+  # SET( ${PACKAGE_NAME}_ENABLE_TESTS ${Trilinos_ENABLE_TESTS} )

 ENDIF()
