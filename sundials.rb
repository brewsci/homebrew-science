require 'formula'

class Sundials < Formula
  homepage 'https://computation.llnl.gov/casc/sundials/main.html'
  url 'http://ftp.mcs.anl.gov/pub/petsc/externalpackages/sundials-2.5.0.tar.gz'
  sha1 '9affcc525269e80c8ec6ae1db1e0a0ff201d07e0'

  depends_on "openblas" => :optional
  depends_on :fortran => :optional
  depends_on :mpi => [:cc, :f77, :optional]

  option "without-check", "Skip build-time checks and examples (not recommended)"

  patch :DATA
  # 1. Fix a minor error in the IDAS example idasRoberts_ASAi_dns.
  # Submitted upstream 2014-06-08; the release cycle for SUNDIALS is long
  # and there is no public-facing repo, so it might take a while for the
  # patch to land in a stable release.
  # 2. Fix to kinsol bugs, submitted 2012-09-05, see
  # http://sundials.2283335.n4.nabble.com/KINSOL-bug-fix-td4652816.html
  # 3. Fix to fkinsol bugs, submitted 2013-05-29, see
  # http://sundials.2283335.n4.nabble.com/fkinsol-stop-with-error-td4652862.html#a4653041
  # 4. Fix to root-finding bugs, submitted 2013-02-13, see
  # http://sundials.2283335.n4.nabble.com/bug-root-finding-code-td4652907.html#a4652911
  # 5. fprintf fixes, which are a combination of the patches in the following 2 msgs:
  # http://sundials.2283335.n4.nabble.com/build-issues-fprintf-td4652946.html#a4652947
  # http://sundials.2283335.n4.nabble.com/CVODES-Warning-With-MEX-Compilation-of-SBPD-Toolbox-in-Matlab-td4652914.html#a4652948
  # 6. Minor bug in CMake file, in case anyone wants to use CMake to build Sundials:
  # http://sundials.2283335.n4.nabble.com/Re-fcmix-interface-td4652859.html#a4652861
  # 7. Minor fixes to root-finding bugs, see
  # http://sundials.2283335.n4.nabble.com/Minor-rootfinding-bug-td4652704.html
  # 8. Fix to cvsHessian_ASA_FSA example, see
  # http://sundials.2283335.n4.nabble.com/Typo-bug-in-example-code-tt4652723.html
  # 9. Fix to bug in defining user_data in CVQuadSenseRhsFn in CVODES, see:
  # http://sundials.2283335.n4.nabble.com/Bug-in-defining-user-data-in-CVQuadSensRhsFn-td4652707.html#a4652717
  # http://sundials.2283335.n4.nabble.com/Typo-bug-in-example-code-tt4652723.html
  # 10. Fix for suspected bug in KINSOL difference quotient
  # http://sundials.2283335.n4.nabble.com/KINSOL-bug-td4652779.html
  # 11. Fix for LAPACK band matrix solver routines, see
  # http://sundials.2283335.n4.nabble.com/KINSOL-bug-td4652779.html
  # 12. Fix for KINSOL band diffence quotient Jacobian
  # http://sundials.2283335.n4.nabble.com/KINSOL-bug-fix-td4652728.html
  # 13. Fix for FKINSOL parallel example, submitted upstream 2014-06-10.

  def install
    config_args = ["--disable-debug", "--disable-dependency-tracking",
                   "--prefix=#{prefix}", "--enable-shared"]
    config_args << "--enable-examples" if build.with? "check"
    config_args += ["--with-blas=openblas",
                    "--with-lapack=openblas"] if build.with? "openblas"
    config_args << ((build.with? "fortran") ? "--enable-fcmix" : "--disable-fcmix")

    # Add MPI root install directory
    # Hardcoded for openmpi, as in the mumps and hypre formulas
    # TODO: Make more general, admit use of mpich2
    if build.with? "mpi"
      config_args += ["--enable-mpi",
                      "--with-mpi-root=#{Formula["open-mpi"].opt_prefix}"]
    else
      config_args << "--disable-mpi"
    end

    system "./configure", *config_args
    system "make"
    if build.with? "check"
      cd "examples" do
        # Non-sensitivity examples can be looped over:
        # Serial CVODE examples
        %w(cvAdvDiff_bnd cvDirectDemo_ls
         cvDiurnal_kry cvDiurnal_kry_bp
         cvKrylovDemo_ls cvKrylovDemo_prec
         cvRoberts_dns cvRoberts_dns_uw).each do |file|
          system "./cvode/serial/#{file}"
        end

        # Serial IDA examples
        %w(idaFoodWeb_bnd idaHeat2D_bnd
         idaHeat2D_kry idaKrylovDemo_ls
         idaRoberts_dns idaSlCrank_dns).each do |file|
          system "./ida/serial/#{file}"
        end

        # Serial KINSOL examples
        %w(kinFerTron_dns kinFoodWeb_kry
         kinKrylovDemo_ls kinLaplace_bnd
         kinRoboKin_dns).each do |file|
          system "./kinsol/serial/#{file}"
        end

        # Serial CVODES examples without command-line args
        # Note: some are CVODES versions of CVODE examples
        %w(cvsAdvDiff_ASAi_bnd cvsAdvDiff_bnd
         cvsDirectDemo_ls cvsDiurnal_kry
         cvsDiurnal_kry_bp cvsFoodWeb_ASAi_kry
         cvsFoodWeb_ASAp_kry cvsHessian_ASA_FSA
         cvsKrylovDemo_ls cvsKrylovDemo_prec
         cvsRoberts_ASAi_dns cvsRoberts_dns
         cvsRoberts_dns_uw).each do |file|
          system "./cvodes/serial/#{file}"
        end

        # Serial CVODES examples with command-line args
        # Not cvsRobertsFSA_dns, cvsDiurnal_FSA_kry, cvsAdvDiff_FSA_non
        system "./cvodes/serial/cvsRoberts_FSA_dns", "-sensi", "stg", "t"
        system "./cvodes/serial/cvsDiurnal_FSA_kry", "-sensi", "stg", "t"
        system "./cvodes/serial/cvsAdvDiff_FSA_non", "-sensi", "stg", "t"

        # Serial IDAS examples without command-line args
        # Note: some are IDAS versions of IDA examples
        # idasRoberts_ASAi_dns segfaults?!?
        %w(idasAkzoNob_ASAi_dns idasAkzoNob_dns
         idasFoodWeb_bnd idasHeat2D_bnd
         idasHeat2D_kry idasHessian_ASA_FSA
         idasKrylovDemo_ls idasRoberts_ASAi_dns
         idasRoberts_dns idasSlCrank_dns
         idasSlCrank_FSA_dns).each do |file|
          system "./idas/serial/#{file}"
        end

        # Serial IDAS examples with command-line args
        system "./idas/serial/idasRoberts_FSA_dns", "-sensi", "stg", "t"

        if build.with? "fortran"

          # Serial FCVODE examples
          %w(fcvAdvDiff_bnd fcvDiurnal_kry
             fcvDiurnal_kry_bp fcvRoberts_dns
             fcvRoberts_dnsL).each do |file|
            system "./cvode/fcmix_serial/#{file}"
          end

          # Serial FIDA examples
          system "./ida/fcmix_serial/fidaRoberts_dns"

          # Serial FKINSOL examples
          system "./kinsol/fcmix_serial/fkinDiagon_kry"

          # There are no Fortran CVODES or IDAS examples (serial or parallel)

        end

        if build.with? "mpi"

          # Parallel CVODE examples; number of processors specified in source
          system "mpiexec -np 4 ./cvode/parallel/cvAdvDiff_non_p"
          system "mpiexec -np 4 ./cvode/parallel/cvDiurnal_kry_bbd_p"
          system "mpiexec -np 4 ./cvode/parallel/cvDiurnal_kry_p"

          # Parallel IDA examples; # processors specified in source
          system "mpiexec -np 4 ./ida/parallel/idaFoodWeb_kry_bbd_p"
          system "mpiexec -np 4 ./ida/parallel/idaFoodWeb_kry_p"
          system "mpiexec -np 4 ./ida/parallel/idaHeat2D_kry_bbd_p"
          system "mpiexec -np 4 ./ida/parallel/idaHeat2D_kry_p"

          # Parallel KINSOL examples; # processors specified in source
          system "mpiexec -np 4 ./kinsol/parallel/kinFoodWeb_kry_bbd_p"
          system "mpiexec -np 4 ./kinsol/parallel/kinFoodWeb_kry_p"

          # Parallel CVODES examples
          system "mpiexec -np 4 ./cvodes/parallel/cvsAdvDiff_ASAp_non_p"
          system "mpiexec -np 4 ./cvodes/parallel/cvsAdvDiff_non_p"
          system "mpiexec -np 4 ./cvodes/parallel/cvsAtmDisp_ASAi_kry_bbd_p"
          system "mpiexec -np 4 ./cvodes/parallel/cvsDiurnal_kry_bbd_p"
          system "mpiexec -np 4 ./cvodes/parallel/cvsDiurnal_kry_p"

          system "mpiexec -np 4 ./cvodes/parallel/cvsAdvDiff_FSA_non_p -sensi stg t"
          system "mpiexec -np 4 ./cvodes/parallel/cvsDiurnal_FSA_kry_p -sensi stg t"

          # Parallel IDAS examples
          system "mpiexec -np 4 ./idas/parallel/idasBruss_ASAp_kry_bbd_p"
          system "mpiexec -np 4 ./idas/parallel/idasBruss_FSA_kry_bbd_p"
          system "mpiexec -np 4 ./idas/parallel/idasBruss_kry_bbd_p"
          system "mpiexec -np 4 ./idas/parallel/idasFoodWeb_kry_bbd_p"
          system "mpiexec -np 4 ./idas/parallel/idasFoodWeb_kry_p"
          system "mpiexec -np 4 ./idas/parallel/idasHeat2D_kry_bbd_p"
          system "mpiexec -np 4 ./idas/parallel/idasHeat2D_kry_p"

          system "mpiexec -np 4 ./idas/parallel/idasHeat2D_FSA_kry_bbd_p -sensi stg t"

          if build.with? "fortran"

            # Parallel FCVODE examples
            system "mpiexec -np 4 ./cvode/fcmix_parallel/fcvDiag_kry_bbd_p"
            system "mpiexec -np 4 ./cvode/fcmix_parallel/fcvDiag_kry_p"
            system "mpiexec -np 4 ./cvode/fcmix_parallel/fcvDiag_non_p"

            # Parallel FIDA examples
            system "mpiexec -np 4 ./ida/fcmix_parallel/fidaHeat2D_kry_bbd_p"

            # Parallel FKINSOL examples
            # TODO: Fix bug in parallel FKINSOL example or ask upstream for fix
            system "mpiexec -np 4 ./kinsol/fcmix_parallel/fkinDiagon_kry_p"

          end

        end

      end
    end

    system "make install"

  end
end

__END__
diff --git a/examples/idas/serial/idasRoberts_ASAi_dns.c b/examples/idas/serial/idasRoberts_ASAi_dns.c
index 2b3d8ad..fecdfb3 100644
--- a/examples/idas/serial/idasRoberts_ASAi_dns.c
+++ b/examples/idas/serial/idasRoberts_ASAi_dns.c
@@ -458,7 +458,7 @@ int main(int argc, char *argv[])
 
   printf("Free memory\n\n");
 
-  IDAFree(ida_mem);
+  IDAFree(&ida_mem);
   N_VDestroy_Serial(yy);
   N_VDestroy_Serial(yp);
   N_VDestroy_Serial(q);
diff --git a/src/kinsol/kinsol.c b/src/kinsol/kinsol.c
index c4bd15d..2a23931 100644
--- a/src/kinsol/kinsol.c
+++ b/src/kinsol/kinsol.c
@@ -1507,7 +1507,7 @@ static int KINStop(KINMem kin_mem, int strategy, booleantype maxStepTaken, int s
     if (setupNonNull && !jacCurrent) {
       /* If the Jacobian is out of date, update it and retry */
       sthrsh = TWO;
-      return(CONTINUE_ITERATIONS);
+      return(RETRY_ITERATION);
     } else {
       /* Give up */
       if (strategy == KIN_NONE)  return(KIN_STEP_LT_STPTOL);
@@ -1589,7 +1589,7 @@ static int KINStop(KINMem kin_mem, int strategy, booleantype maxStepTaken, int s
 	if (setupNonNull && !jacCurrent) {
           /* If the Jacobian is out of date, update it and retry */
 	  sthrsh = TWO;
-	  return(RETRY_ITERATION);
+	  return(CONTINUE_ITERATIONS);
 	} else {
           /* Otherwise, we cannot do anything, so just return. */
         }
diff --git a/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f b/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f
index dd51516..74bc21c 100644
--- a/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f
+++ b/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f
@@ -57,14 +57,14 @@ c     number of this process.
       call mpi_init(ier)
       if (ier .ne. 0) then
          write(6,1210) ier
- 1210    format('MPI_ERROR: MPI_INIT returned IER = ', i2)
+ 1210    format('MPI_ERROR: MPI_INIT returned IER = ', i4)
          stop
       endif
 
       call fnvinitp(mpi_comm_world, 3, nlocal, neq, ier)
       if (ier .ne. 0) then
          write(6,1220) ier
- 1220    format('SUNDIALS_ERROR: FNVINITP returned IER = ', i2)
+ 1220    format('SUNDIALS_ERROR: FNVINITP returned IER = ', i4)
          call mpi_finalize(ier)
          stop
       endif
@@ -72,7 +72,7 @@ c     number of this process.
       call mpi_comm_size(mpi_comm_world, size, ier)
       if (ier .ne. 0) then
          write(6,1222) ier
- 1222    format('MPI_ERROR: MPI_COMM_SIZE returned IER = ', i2)
+ 1222    format('MPI_ERROR: MPI_COMM_SIZE returned IER = ', i4)
          call mpi_abort(mpi_comm_world, 1, ier)
          stop
       endif
@@ -88,7 +88,7 @@ c     number of this process.
       call mpi_comm_rank(mpi_comm_world, rank, ier)
       if (ier .ne. 0) then
          write(6,1224) ier
- 1224    format('MPI_ERROR: MPI_COMM_RANK returned IER = ', i2)
+ 1224    format('MPI_ERROR: MPI_COMM_RANK returned IER = ', i4)
          call mpi_abort(mpi_comm_world, 1, ier)
          stop
       endif
@@ -107,7 +107,7 @@ c     number of this process.
       
       if (ier .ne. 0) then
          write(6,1231)ier
- 1231    format('SUNDIALS_ERROR: FKINMALLOC returned IER = ', i2)
+ 1231    format('SUNDIALS_ERROR: FKINMALLOC returned IER = ', i4)
          call mpi_abort(mpi_comm_world, 1, ier)
          stop
       endif
@@ -130,8 +130,8 @@ c     number of this process.
       call fkinsol(uu, globalstrat, scale, scale, ier)
       if (ier .lt. 0) then
          write(6,1242) ier, iout(9)
- 1242    format('SUNDIALS_ERROR: FKINSOL returned IER = ', i2, /,
-     1          '                Linear Solver returned IER = ', i2)
+ 1242    format('SUNDIALS_ERROR: FKINSOL returned IER = ', i4, /,
+     1          '                Linear Solver returned IER = ', i4)
          call mpi_abort(mpi_comm_world, 1, ier)
          stop
       endif
diff --git a/examples/kinsol/fcmix_serial/fkinDiagon_kry.f b/examples/kinsol/fcmix_serial/fkinDiagon_kry.f
index 9c050d8..1de43f2 100644
--- a/examples/kinsol/fcmix_serial/fkinDiagon_kry.f
+++ b/examples/kinsol/fcmix_serial/fkinDiagon_kry.f
@@ -46,7 +46,7 @@ c * * * * * * * * * * * * * * * * * * * * * *
       call fnvinits(3, neq, ier)
       if (ier .ne. 0) then
          write(6,1220) ier
- 1220    format('SUNDIALS_ERROR: FNVINITS returned IER = ', i2)
+ 1220    format('SUNDIALS_ERROR: FNVINITS returned IER = ', i4)
          stop
       endif
 
@@ -59,7 +59,7 @@ c * * * * * * * * * * * * * * * * * * * * * *
       call fkinmalloc(iout, rout, ier)
       if (ier .ne. 0) then
          write(6,1230) ier
- 1230    format('SUNDIALS_ERROR: FKINMALLOC returned IER = ', i2)
+ 1230    format('SUNDIALS_ERROR: FKINMALLOC returned IER = ', i4)
          stop
       endif
 
@@ -71,7 +71,7 @@ c * * * * * * * * * * * * * * * * * * * * * *
       call fkinspgmr(maxl, maxlrst, ier)
       if (ier .ne. 0) then
          write(6,1235) ier
- 1235    format('SUNDIALS_ERROR: FKINSPGMR returned IER = ', i2)
+ 1235    format('SUNDIALS_ERROR: FKINSPGMR returned IER = ', i4)
          call fkinfree
          stop
       endif
@@ -88,8 +88,8 @@ c * * * * * * * * * * * * * * * * * * * * * *
       call fkinsol(uu, globalstrat, scale, scale, ier)
       if (ier .lt. 0) then
          write(6,1242) ier, iout(9)
- 1242    format('SUNDIALS_ERROR: FKINSOL returned IER = ', i2, /,
-     1          '                Linear Solver returned IER = ', i2)
+ 1242    format('SUNDIALS_ERROR: FKINSOL returned IER = ', i4, /,
+     1          '                Linear Solver returned IER = ', i4)
          call fkinfree
          stop
       endif
diff --git a/src/kinsol/fcmix/fkinsol.c b/src/kinsol/fcmix/fkinsol.c
index 933fa08..28bfea7 100644
--- a/src/kinsol/fcmix/fkinsol.c
+++ b/src/kinsol/fcmix/fkinsol.c
@@ -391,5 +391,5 @@ int FKINfunc(N_Vector uu, N_Vector fval, void *user_data)
 
   FK_FUN(udata, fdata, &ier);
 
-  return(0);
+  return(ier);
 }
diff --git a/src/kinsol/fcmix/fkinsol.h b/src/kinsol/fcmix/fkinsol.h
index 609acf9..7c1fa25 100644
--- a/src/kinsol/fcmix/fkinsol.h
+++ b/src/kinsol/fcmix/fkinsol.h
@@ -89,7 +89,9 @@
      It must set the FVAL array to f(u), the system function, as a
      function of the array UU = u. Here UU and FVAL are arrays representing
      vectors, which are distributed vectors in the parallel case.
-     IER is a return flag (currently not used).
+     IER is a return flag, which should be 0 if FKFUN was successful.
+     Return IER > 0 if a recoverable error occurred (and KINSOL is to try
+     to recover).  Return IER < 0 if an unrecoverable error occurred.
 
  (2s) Optional user-supplied dense Jacobian approximation routine: FKDJAC
   
diff --git a/src/cvode/cvode.c b/src/cvode/cvode.c
index 466a6fe..4dc7d13 100644
--- a/src/cvode/cvode.c
+++ b/src/cvode/cvode.c
@@ -3922,6 +3922,9 @@ static int CVRootfind(CVodeMem cv_mem)
   side = 0;  sideprev = -1;
   loop {                                    /* Looping point */
 
+    /* If interval size is already less than tolerance ttol, break. */
+    if (ABS(thi - tlo) <= ttol) break;
+
     /* Set weight alpha.
        On the first two passes, set alpha = 1.  Thereafter, reset alpha
        according to the side (low vs high) of the subinterval in which
diff --git a/src/cvodes/cvodes.c b/src/cvodes/cvodes.c
index df7ab91..1186cbb 100644
--- a/src/cvodes/cvodes.c
+++ b/src/cvodes/cvodes.c
@@ -8324,6 +8324,9 @@ static int cvRootFind(CVodeMem cv_mem)
   side = 0;  sideprev = -1;
   loop {                                    /* Looping point */
 
+    /* If interval size is already less than tolerance ttol, break. */
+    if (ABS(thi - tlo) <= ttol) break;
+
     /* Set weight alpha.
        On the first two passes, set alpha = 1.  Thereafter, reset alpha
        according to the side (low vs high) of the subinterval in which
diff --git a/src/ida/ida.c b/src/ida/ida.c
index 7c05cae..f34b421 100644
--- a/src/ida/ida.c
+++ b/src/ida/ida.c
@@ -3246,6 +3246,9 @@ static int IDARootfind(IDAMem IDA_mem)
   side = 0;  sideprev = -1;
   loop {                                    /* Looping point */
 
+    /* If interval size is already less than tolerance ttol, break. */
+    if (ABS(thi - tlo) <= ttol) break;
+
     /* Set weight alph.
        On the first two passes, set alph = 1.  Thereafter, reset alph
        according to the side (low vs high) of the subinterval in which
diff --git a/src/idas/idas.c b/src/idas/idas.c
index dab8af2..6c66c68 100644
--- a/src/idas/idas.c
+++ b/src/idas/idas.c
@@ -6688,6 +6688,9 @@ static int IDARootfind(IDAMem IDA_mem)
   side = 0;  sideprev = -1;
   loop {                                    /* Looping point */
 
+    /* If interval size is already less than tolerance ttol, break. */
+    if (ABS(thi - tlo) <= ttol) break;
+
     /* Set weight alph.
        On the first two passes, set alph = 1.  Thereafter, reset alph
        according to the side (low vs high) of the subinterval in which
diff --git a/src/cvode/cvode.c b/src/cvode/cvode.c
index 4dc7d13..6496cf8 100644
--- a/src/cvode/cvode.c
+++ b/src/cvode/cvode.c
@@ -4135,20 +4135,19 @@ void CVProcessError(CVodeMem cv_mem,
 
   va_start(ap, msgfmt);
 
+  /* Compose the message */
+
+  vsprintf(msg, msgfmt, ap);
+
   if (cv_mem == NULL) {    /* We write to stderr */
 
 #ifndef NO_FPRINTF_OUTPUT
     fprintf(stderr, "\n[%s ERROR]  %s\n  ", module, fname);
-    fprintf(stderr, msgfmt);
-    fprintf(stderr, "\n\n");
+    fprintf(stderr, "%s\n\n", msg);
 #endif
 
   } else {                 /* We can call ehfun */
 
-    /* Compose the message */
-
-    vsprintf(msg, msgfmt, ap);
-
     /* Call ehfun */
 
     ehfun(error_code, module, fname, msg, eh_data);
diff --git a/src/cvodes/cvodes.c b/src/cvodes/cvodes.c
index 1186cbb..28dba5b 100644
--- a/src/cvodes/cvodes.c
+++ b/src/cvodes/cvodes.c
@@ -8961,8 +8961,7 @@ void cvProcessError(CVodeMem cv_mem,
 
 #ifndef NO_FPRINTF_OUTPUT
     fprintf(stderr, "\n[%s ERROR]  %s\n  ", module, fname);
-    fprintf(stderr, msg);
-    fprintf(stderr, "\n\n");
+    fprintf(stderr, "%s\n\n", msg);
 #endif
 
   } else {                 /* We can call ehfun */
diff --git a/src/ida/ida.c b/src/ida/ida.c
index f34b421..8c17076 100644
--- a/src/ida/ida.c
+++ b/src/ida/ida.c
@@ -3377,20 +3377,19 @@ void IDAProcessError(IDAMem IDA_mem,
 
   va_start(ap, msgfmt);
 
+  /* Compose the message */
+
+  vsprintf(msg, msgfmt, ap);
+
   if (IDA_mem == NULL) {    /* We write to stderr */
 
 #ifndef NO_FPRINTF_OUTPUT
     fprintf(stderr, "\n[%s ERROR]  %s\n  ", module, fname);
-    fprintf(stderr, msgfmt);
-    fprintf(stderr, "\n\n");
+    fprintf(stderr, "%s\n\n", msg);
 #endif
 
   } else {                 /* We can call ehfun */
 
-    /* Compose the message */
-
-    vsprintf(msg, msgfmt, ap);
-
     /* Call ehfun */
 
     ehfun(error_code, module, fname, msg, eh_data);
diff --git a/src/idas/idas.c b/src/idas/idas.c
index 6c66c68..7114d78 100644
--- a/src/idas/idas.c
+++ b/src/idas/idas.c
@@ -7178,20 +7178,19 @@ void IDAProcessError(IDAMem IDA_mem,
 
   va_start(ap, msgfmt);
 
+  /* Compose the message */
+  vsprintf(msg, msgfmt, ap);
+
   if (IDA_mem == NULL) {    /* We write to stderr */
 
 #ifndef NO_FPRINTF_OUTPUT
     fprintf(stderr, "\n[%s ERROR]  %s\n  ", module, fname);
-    fprintf(stderr, msgfmt);
-    fprintf(stderr, "\n\n");
+    fprintf(stderr, "%s\n\n", msg);
 #endif
 
   } else {                 
     /* We can call ehfun */
 
-    /* Compose the message */
-    vsprintf(msg, msgfmt, ap);
-
     /* Call ehfun */
     ehfun(error_code, module, fname, msg, eh_data);
   }
diff --git a/src/kinsol/kinsol.c b/src/kinsol/kinsol.c
index 2a23931..0f6e49f 100644
--- a/src/kinsol/kinsol.c
+++ b/src/kinsol/kinsol.c
@@ -1872,20 +1872,19 @@ void KINProcessError(KINMem kin_mem,
 
   va_start(ap, msgfmt);
 
+  /* Compose the message */
+
+  vsprintf(msg, msgfmt, ap);
+
   if (kin_mem == NULL) {    /* We write to stderr */
 
 #ifndef NO_FPRINTF_OUTPUT
     fprintf(stderr, "\n[%s ERROR]  %s\n  ", module, fname);
-    fprintf(stderr, msgfmt);
-    fprintf(stderr, "\n\n");
+    fprintf(stderr, "%s\n\n", msg);
 #endif
 
   } else {                 /* We can call ehfun */
 
-    /* Compose the message */
-
-    vsprintf(msg, msgfmt, ap);
-
     /* Call ehfun */
 
     ehfun(error_code, module, fname, msg, eh_data);
diff --git a/config/SundialsMPIC.cmake b/config/SundialsMPIC.cmake
index c708e68..b3bf313 100644
--- a/config/SundialsMPIC.cmake
+++ b/config/SundialsMPIC.cmake
@@ -110,7 +110,7 @@ if(MPIC_PERFORM_TEST)
     "}\n")
   # Use TRY_COMPILE to make the target "mpictest"
   try_compile(MPITEST_OK ${MPITest_DIR} ${MPITest_DIR}
-    mpitest OUTPUT_VARIABLE MY_OUTPUT)
+    mpictest OUTPUT_VARIABLE MY_OUTPUT)
   # To ensure we do not use stuff from the previous attempts, 
   # we must remove the CMakeFiles directory.
   file(REMOVE_RECURSE ${MPITest_DIR}/CMakeFiles)
diff --git a/src/cvode/cvode.c b/src/cvode/cvode.c
index 6496cf8..0852914 100644
--- a/src/cvode/cvode.c
+++ b/src/cvode/cvode.c
@@ -3909,7 +3909,8 @@ static int CVRootfind(CVodeMem cv_mem)
     for (i = 0; i < nrtfn; i++) {
       iroots[i] = 0;
       if(!gactive[i]) continue;
-      if (ABS(ghi[i]) == ZERO) iroots[i] = glo[i] > 0 ? -1:1;
+      if ( (ABS(ghi[i]) == ZERO) && (rootdir[i]*glo[i] <= ZERO) ) 
+	iroots[i] = glo[i] > 0 ? -1:1;
     }
     return(RTFOUND);
   }
diff --git a/src/cvodes/cvodes.c b/src/cvodes/cvodes.c
index 28dba5b..b1bf77c 100644
--- a/src/cvodes/cvodes.c
+++ b/src/cvodes/cvodes.c
@@ -8311,7 +8311,8 @@ static int cvRootFind(CVodeMem cv_mem)
     for (i = 0; i < nrtfn; i++) {
       iroots[i] = 0;
       if(!gactive[i]) continue;
-      if (ABS(ghi[i]) == ZERO) iroots[i] = glo[i] > 0 ? -1:1;
+      if ( (ABS(ghi[i]) == ZERO) && (rootdir[i]*glo[i] <= ZERO) ) 
+	iroots[i] = glo[i] > 0 ? -1:1;
     }
     return(RTFOUND);
   }
diff --git a/src/ida/ida.c b/src/ida/ida.c
index 8c17076..a951f0f 100644
--- a/src/ida/ida.c
+++ b/src/ida/ida.c
@@ -3233,7 +3233,8 @@ static int IDARootfind(IDAMem IDA_mem)
     for (i = 0; i < nrtfn; i++) {
       iroots[i] = 0;
       if(!gactive[i]) continue;
-      if (ABS(ghi[i]) == ZERO) iroots[i] = glo[i] > 0 ? -1:1;
+      if ( (ABS(ghi[i]) == ZERO) && (rootdir[i]*glo[i] <= ZERO) ) 
+	iroots[i] = glo[i] > 0 ? -1:1;
     }
     return(RTFOUND);
   }
diff --git a/src/idas/idas.c b/src/idas/idas.c
index 7114d78..f32246c 100644
--- a/src/idas/idas.c
+++ b/src/idas/idas.c
@@ -6675,7 +6675,8 @@ static int IDARootfind(IDAMem IDA_mem)
     for (i = 0; i < nrtfn; i++) {
       iroots[i] = 0;
       if(!gactive[i]) continue;
-      if (ABS(ghi[i]) == ZERO) iroots[i] = glo[i] > 0 ? -1:1;
+      if ( (ABS(ghi[i]) == ZERO) && (rootdir[i]*glo[i] <= ZERO) ) 
+	iroots[i] = glo[i] > 0 ? -1:1;
     }
     return(RTFOUND);
   }
diff --git a/examples/cvodes/serial/cvsHessian_ASA_FSA.c b/examples/cvodes/serial/cvsHessian_ASA_FSA.c
index 7145a4c..0105254 100644
--- a/examples/cvodes/serial/cvsHessian_ASA_FSA.c
+++ b/examples/cvodes/serial/cvsHessian_ASA_FSA.c
@@ -637,7 +637,7 @@ static int fB2(realtype t, N_Vector y, N_Vector *yS,
 
   Ith(yBdot,4) = 2.0*p1*y1 * m1     + l1 * 2.0*p1*s1              - s1;
   Ith(yBdot,5) = m2 + p2*p2*y3 * m3 + l3 * (2.0*p2*y3 + p2*p2*s3) - s2;
-  Ith(yBdot,6) = m1 + p2*p2*y2 * m3 + l3 * (2.0*p2*y3 + p2*p2*s2) - s3;
+  Ith(yBdot,6) = m1 + p2*p2*y2 * m3 + l3 * (2.0*p2*y2 + p2*p2*s2) - s3;
 
 
   return(0);
diff --git a/src/cvodes/cvodes.c b/src/cvodes/cvodes.c
index b1bf77c..a456123 100644
--- a/src/cvodes/cvodes.c
+++ b/src/cvodes/cvodes.c
@@ -1972,7 +1972,7 @@ int CVodeQuadSensInit(void *cvode_mem, CVQuadSensRhsFn fQS, N_Vector *yQS0)
     cv_mem->cv_fQSDQ = FALSE;
     cv_mem->cv_fQS = fQS;
 
-    cv_mem->cv_fS_data = cv_mem->cv_user_data;
+    cv_mem->cv_fQS_data = cv_mem->cv_user_data;
 
   }
 
diff --git a/src/kinsol/kinsol_direct.c b/src/kinsol/kinsol_direct.c
index 8365aaf..d7d2d96 100644
--- a/src/kinsol/kinsol_direct.c
+++ b/src/kinsol/kinsol_direct.c
@@ -364,6 +364,10 @@ int kinDlsDenseDQJac(long int N,
   kin_mem = (KINMem) data;
   kindls_mem = (KINDlsMem) lmem;
 
+  retval = func(u, fu, user_data);
+  nfeDQ++;
+  if (retval != 0) return(-1);
+
   /* Save pointer to the array in tmp2 */
   tmp2_data = N_VGetArrayPointer(tmp2);
 
@@ -441,6 +445,10 @@ int kinDlsBandDQJac(long int N, long int mupper, long int mlower,
   kin_mem = (KINMem) data;
   kindls_mem = (KINDlsMem) lmem;
 
+  retval = func(u, fu, user_data); 
+  nfeDQ++; 
+  if (retval != 0) return(-1);
+
   /* Rename work vectors for use as temporary values of u and fu */
   futemp = tmp1;
   utemp = tmp2;
diff --git a/src/cvode/cvode_lapack.c b/src/cvode/cvode_lapack.c
index c058bea..c76e370 100644
--- a/src/cvode/cvode_lapack.c
+++ b/src/cvode/cvode_lapack.c
@@ -305,7 +305,7 @@ int CVLapackBand(void *cvode_mem, int N, int mupper, int mlower)
   }
 
   /* Set extended upper half-bandwith for M (required for pivoting) */
-  smu = MIN(n-1, mu + ml);
+  smu = mu + ml;
 
   /* Allocate memory for M, pivot array, and savedJ */
   M = NULL;
diff --git a/src/cvodes/cvodes_lapack.c b/src/cvodes/cvodes_lapack.c
index 931ba86..2abedd3 100644
--- a/src/cvodes/cvodes_lapack.c
+++ b/src/cvodes/cvodes_lapack.c
@@ -303,7 +303,7 @@ int CVLapackBand(void *cvode_mem, int N, int mupper, int mlower)
   }
 
   /* Set extended upper half-bandwith for M (required for pivoting) */
-  smu = MIN(n-1, mu + ml);
+  smu = mu + ml;
 
   /* Allocate memory for M, savedJ, and pivot arrays */
   M = NULL;
diff --git a/src/ida/ida_lapack.c b/src/ida/ida_lapack.c
index 86530ea..05aae9a 100644
--- a/src/ida/ida_lapack.c
+++ b/src/ida/ida_lapack.c
@@ -293,7 +293,7 @@ int IDALapackBand(void *ida_mem, int N, int mupper, int mlower)
   }
 
   /* Set extended upper half-bandwith for M (required for pivoting) */
-  smu = MIN(n-1, mu + ml);
+  smu = mu + ml;
 
   /* Allocate memory for JJ and pivot arrays */
   JJ = NULL;
diff --git a/src/idas/idas_lapack.c b/src/idas/idas_lapack.c
index 20d7640..ab35a56 100644
--- a/src/idas/idas_lapack.c
+++ b/src/idas/idas_lapack.c
@@ -293,7 +293,7 @@ int IDALapackBand(void *ida_mem, int N, int mupper, int mlower)
   }
 
   /* Set extended upper half-bandwith for M (required for pivoting) */
-  smu = MIN(n-1, mu + ml);
+  smu = mu + ml;
 
   /* Allocate memory for JJ and pivot arrays */
   JJ = NULL;
diff --git a/src/kinsol/kinsol_lapack.c b/src/kinsol/kinsol_lapack.c
index 08fa4b3..cda12a2 100644
--- a/src/kinsol/kinsol_lapack.c
+++ b/src/kinsol/kinsol_lapack.c
@@ -291,7 +291,7 @@ int KINLapackBand(void *kinmem, int N, int mupper, int mlower)
   }
 
   /* Set extended upper half-bandwith for M (required for pivoting) */
-  smu = MIN(n-1, mu + ml);
+  smu = mu + ml;
 
   /* Allocate memory for J and pivot array */
   J = NULL;
diff --git a/src/kinsol/kinsol_direct.c b/src/kinsol/kinsol_direct.c
index d7d2d96..60cee91 100644
--- a/src/kinsol/kinsol_direct.c
+++ b/src/kinsol/kinsol_direct.c
@@ -471,7 +471,7 @@ int kinDlsBandDQJac(long int N, long int mupper, long int mlower,
     
     /* Increment all utemp components in group */
     for(j=group-1; j < N; j+=width) {
-      inc = sqrt_relfunc*MAX(ABS(u_data[j]), ABS(uscale_data[j]));
+      inc = sqrt_relfunc*MAX(ABS(u_data[j]), ONE/ABS(uscale_data[j]));
       utemp_data[j] += inc;
     }
 
@@ -483,7 +483,7 @@ int kinDlsBandDQJac(long int N, long int mupper, long int mlower,
     for (j=group-1; j < N; j+=width) {
       utemp_data[j] = u_data[j];
       col_j = BAND_COL(Jac,j);
-      inc = sqrt_relfunc*MAX(ABS(u_data[j]), ABS(uscale_data[j]));
+      inc = sqrt_relfunc*MAX(ABS(u_data[j]), ONE/ABS(uscale_data[j]));
       inc_inv = ONE/inc;
       i1 = MAX(0, j-mupper);
       i2 = MIN(j+mlower, N-1);
diff --git a/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f b/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f
index 74bc21c..6da94c8 100644
--- a/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f
+++ b/examples/kinsol/fcmix_parallel/fkinDiagon_kry_p.f
@@ -184,6 +184,8 @@ c     function with the following name and form.
       do 10 i = 1, nlocal
  10      fval(i) = uu(i) * uu(i) - (i + baseadd) * (i + baseadd)
       
+      ier = 0
+
       return
       end
       
