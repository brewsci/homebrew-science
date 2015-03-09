class Abinit < Formula
  homepage "http://www.abinit.org"
  url "http://ftp.abinit.org/abinit-7.10.2.tar.gz"
  sha256 "cbead80096d97f1c8d08ccb3b9b2851ac1e56accaebe551d9ab29757e9cd531e"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "a83e4d643debd45d7c3bcfdd1f20f736a7e64933" => :yosemite
    sha1 "b106a857ba1430ef060d8164d5f6f2cf000e89f3" => :mavericks
    sha1 "93d318b7e3ded576a88ace4b09a208d21dca1b2f" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"
  option "with-testsuite", "Run full test suite (time consuming)"

  depends_on "cmake" => :build
  depends_on :python => :build

  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran
  depends_on "veclibfort"
  depends_on "scalapack" => :recommended
  depends_on "fftw" => ["with-mpi", "with-fortran", :recommended]
  depends_on "libxc" => :recommended
  depends_on "netcdf" => ["with-fortran", :recommended]
  depends_on "gsl" => :recommended

  # Patch:
  # Correct a bug when NetCDF is used without ETSF_IO library.
  # This bug has been committed upstream; to be removed for ABINIT 7.10.4+
  patch :DATA

  def install
    # Environment variables CC, CXX, etc. will be ignored.
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "F77"
    ENV.delete "FC"
    args = %W[CC=#{ENV["MPICC"]}
              CXX=#{ENV["MPICXX"]}
              F77=#{ENV["MPIF77"]}
              FC=#{ENV["MPIFC"]}
              --prefix=#{prefix}
              --enable-mpi=yes
              --with-mpi-prefix=#{HOMEBREW_PREFIX}
              --enable-optim=safe
              --enable-openmp=no
              --enable-gw-dpc
           ]

    dft_flavor = "none"
    trio_flavor = "none"

    if build.with? "scalapack"
      args << "--with-linalg-flavor=custom+scalapack"
      args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lveclibfort -L#{Formula["scalapack"].opt_lib} -lscalapack"
    else
      args << "--with-linalg-flavor=custom"
      args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lveclibfort"
    end

    if build.with? "netcdf"
      trio_flavor = "netcdf"
      args << "--with-netcdf-incs=-I#{Formula["netcdf"].opt_include}"
      args << "--with-netcdf-libs=-L#{Formula["netcdf"].opt_lib} -lnetcdff -lnetcdf"
    end

    if build.with? "gsl"
      args << "--with-math-flavor=gsl"
      args << "--with-math-incs=-I#{Formula["gsl"].opt_include}"
      args << "--with-math-libs=-L#{Formula["gsl"].opt_lib} -lgsl"
    end

    if build.with? "libxc"
      dft_flavor = "libxc"
      args << "--with-libxc-incs=-I#{Formula["libxc"].opt_include}"
      args << "--with-libxc-libs=-L#{Formula["libxc"].opt_lib} -lxc -lxcf90"
      # Patch to make libXC 2.2+ supported by Abinit 7.10;
      # libXC 2.2 will be supported in Abinit 8.0
      inreplace "configure", "(major != 2) || (minor < 0) || (minor > 1)",
                             "(major != 2) || (minor < 2) || (minor > 3)"
    end

    # need to link against single precision as well, see https://trac.macports.org/ticket/45617 and http://forum.abinit.org/viewtopic.php?f=3&t=2631
    if build.with? "fftw"
      args << "--with-fft-flavor=fftw3"
      args << "--with-fft-incs=-I#{Formula["fftw"].opt_include}"
      args << "--with-fft-libs=-L#{Formula["fftw"].opt_lib} -lfftw3 -lfftw3f -lfftw3_mpi -lfftw3f_mpi"
    end

    args << "--with-dft-flavor=#{dft_flavor}"
    args << "--with-trio-flavor=#{trio_flavor}"

    system "./configure", *args
    system "make"

    if build.with? "check"
      cd "tests"
      if build.with? "testsuite"
        system "./runtests.py -n 3 2>&1 | tee make-check.log"
      else
        system "./runtests.py built-in fast 2>&1 | tee make-check.log"
      end
      ohai `grep ", succeeded:" "make-check.log"`.chomp
      prefix.install "make-check.log"
      cd ".."
    end

    system "make", "install"
  end

  test do
    system "#{bin}/abinit", "-b"
  end
end

# Eliminate this patch for Abinit v7.10.4+
__END__
diff --git a/src/57_iovars/outvars.F90 b/src/57_iovars/outvars.F90
index 558b783..5ec12f5 100644
--- a/src/57_iovars/outvars.F90
+++ b/src/57_iovars/outvars.F90
@@ -352,7 +352,7 @@ subroutine outvars(choice,dmatpuflag,dtsets,filnam4,iout,&

 #if defined HAVE_TRIO_ETSF_IO
  call etsf_io_low_close(abs(ncid), lstat)
-#elif defined HAVE_TRIO_NETCDF
+#elif 0
  ncerr=nf90_close(ncid)
  if (ncerr/=nf90_NoErr) then
    message='Netcdf Error while closing the OUT.nc file: '//trim(nf90_strerror(ncerr))
diff --git a/src/57_iovars/write_var_netcdf.F90 b/src/57_iovars/write_var_netcdf.F90
index e0e3400..fe5f190 100644
--- a/src/57_iovars/write_var_netcdf.F90
+++ b/src/57_iovars/write_var_netcdf.F90
@@ -116,7 +116,7 @@ type(etsf_io_low_error) :: error_data
    end if
  end if

-#elif defined HAVE_TRIO_NETCDF
+#elif 0
  if (ncid>0) then
 !  ### Put the file in definition mode
    ncerr=nf90_redef(ncid)
diff --git a/src/94_scfcv/outscfcv.F90 b/src/94_scfcv/outscfcv.F90
index 92fcc52..7d51105 100644
--- a/src/94_scfcv/outscfcv.F90
+++ b/src/94_scfcv/outscfcv.F90
@@ -1080,7 +1080,7 @@ subroutine outscfcv(atindx1,cg,compch_fft,compch_sph,cprj,dimcprj,dtefield,dtfil
    if (isalchemical(Crystal)) then
      MSG_WARNING("Alchemical pseudos are not supported by ETSF-IO, GSR file won't be produced")
    else
-#ifdef HAVE_TRIO_NETCDF
+#ifdef HAVE_TRIO_ETSF_IO
      NCF_CHECK(ncfile_create(ncf,fname,NF90_CLOBBER),"Creating GSR file")
      call crystal_ncwrite(Crystal,ncf%ncid)
      call ebands_ncwrite(Bands,dtset%nshiftk_orig,dtset%shiftk_orig,dtset%nshiftk,dtset%shiftk,dtset%ngkpt,dtset%kptrlatt,ncf%ncid)
