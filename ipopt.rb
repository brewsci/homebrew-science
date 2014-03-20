require 'formula'

class Ipopt < Formula
  homepage 'https://projects.coin-or.org/Ipopt'
  url 'http://www.coin-or.org/download/source/Ipopt/Ipopt-3.11.7.tgz'
  sha1 '4547db1acbd65aad9edbed115a7812fbfd6d2d3a'
  head 'https://projects.coin-or.org/svn/Ipopt/trunk', :using => :svn

  option 'without-check', 'Skip build-time tests (not recommended)'

  depends_on 'asl' => :recommended
  depends_on 'openblas' => :optional
  depends_on 'pkg-config' => :build
  depends_on 'mumps' => (build.with? 'openblas') ? ['with-openblas'] : :build

  depends_on :fortran

  def mumps_options
    Tab.for_formula(Formula["mumps"]).used_options
  end

  def patches
    # http://list.coin-or.org/pipermail/ipopt/2014-February/003651.html
    # This patch may need to be removed in future updates.
    DATA unless mumps_options.include? "without-mpi"
  end

  def install
    ENV.delete('MPICC')  # configure will pick these up and use them to link
    ENV.delete('MPIFC')  # which leads to the linker crashing.
    ENV.delete('MPICXX')
    mumps_libs = %w[-ldmumps -lmumps_common -lpord]

    # See whether the parallel or sequential MUMPS library was built.
    if mumps_options.include? 'without-mpi'
      mumps_libs << '-lmpiseq'
      mumps_incdir = Formula["mumps"].libexec / 'include'
    else
      # The MPI libs were installed as a MUMPS dependency.
      mumps_libs += %w[-lmpi_cxx -lmpi_mpifh]
      mumps_incdir = Formula["mumps"].include
    end
    mumps_libcmd = "-L#{Formula["mumps"].lib} " + mumps_libs.join(' ')

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-mumps-incdir=#{mumps_incdir}",
            "--with-mumps-lib=#{mumps_libcmd}",
            "--enable-shared",
            "--enable-static"]

    if build.with? 'openblas'
      args << "--with-blas-incdir=#{Formula["openblas"].include}"
      args << "--with-blas-lib=-L#{Formula["openblas"].lib} -lopenblas"
      args << "--with-lapack-incdir=#{Formula["openblas"].include}"
      args << "--with-lapack-lib=-L#{Formula["openblas"].lib} -lopenblas"
    end

    if build.with? 'asl'
      args << "--with-asl-incdir=#{Formula["asl"].include}/asl"
      args << "--with-asl-lib=-L#{Formula["asl"].lib} -lasl -lfuncadd0"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make test" if build.with? "check"
    system "make install"
  end
end

__END__
diff --git a/Ipopt/src/Algorithm/LinearSolvers/IpMumpsSolverInterface.cpp b/Ipopt/src/Algorithm/LinearSolvers/IpMumpsSolverInterface.cpp
index bf6bb92..7cff8fe 100644
--- a/Ipopt/src/Algorithm/LinearSolvers/IpMumpsSolverInterface.cpp
+++ b/Ipopt/src/Algorithm/LinearSolvers/IpMumpsSolverInterface.cpp
@@ -57,7 +57,9 @@ namespace Ipopt
     int argc=1;
     char ** argv = 0;
     int myid;
-    MPI_Init(&argc, &argv);
+    int is_initialized = 0;
+    MPI_Initialized(&is_initialized);
+    if (!is_initialized) MPI_Init(&argc, &argv);
     MPI_Comm_rank(MPI_COMM_WORLD, &myid);
     mumps_->n = 0;
     mumps_->nz = 0;
@@ -84,7 +86,9 @@ namespace Ipopt
     DMUMPS_STRUC_C* mumps_ = (DMUMPS_STRUC_C*)mumps_ptr_;
     mumps_->job = -2; //terminate mumps
     dmumps_c(mumps_);
-    MPI_Finalize();
+    int is_finalized = 0;
+    MPI_Finalized(&is_finalized);
+    if (!is_finalized) MPI_Finalize();
     delete [] mumps_->a;
     delete mumps_;
   }
