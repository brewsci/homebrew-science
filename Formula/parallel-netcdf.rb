class ParallelNetcdf < Formula
  desc "NetCDF library for parallel I/O"
  homepage "https://trac.mcs.anl.gov/projects/parallel-netcdf"
  url "http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/parallel-netcdf-1.7.0.tar.gz"
  sha256 "52f0d106c470a843c6176318141f74a21e6ece3f70ee8fe261c6b93e35f70a94"
  revision 2

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  option "without-cxx", "Don't compile C++ bindings"
  option "without-fortran", "Don't compile Fortran bindings"
  # disabled (see comment below): option "without-test", "Disable checks (not recommended)"

  depends_on :mpi => [:cc, :cxx, :f90]
  depends_on :fortran

  def install
    args = "--prefix=#{prefix}"

    ENV["CC"] = ENV["MPICC"]
    ENV["CXX"] = ENV["MPICXX"]
    ENV["FC"] = ENV["MPIFC"]

    args << "--disable-fortran" if build.without? "fortran"
    args << "--disable-cxx" if build.without? "cxx"

    system "./configure", *args
    system "make"
    # `make check` is disabled by default because
    # it fails to pass if built with `open-mpi`:
    # https://trac.mcs.anl.gov/projects/parallel-netcdf/ticket/19
    # system "make", "check" if build.with? "test"
    ENV.deparallelize do
      system "make", "install", "MANDIR=#{man}", "prefix=#{prefix}"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "pnetcdf.h"
      int main()
      {
        printf("version: %d.%d", PNETCDF_VERSION_MAJOR, PNETCDF_VERSION_MINOR);
        return 0;
      }
    EOS
    (testpath/"test_mpi.c").write <<-EOS.undent
      #include <stdlib.h>
      #include <mpi.h>
      #include <pnetcdf.h>
      #include <stdio.h>

      static void handle_error(int status, int lineno)
      {
          fprintf(stderr, "Error at line %d: %s\\n", lineno, ncmpi_strerror(status));
          MPI_Abort(MPI_COMM_WORLD, 1);
      }

      int main(int argc, char **argv) {
          int ret, ncfile, nprocs, rank, dimid, varid1, varid2, ndims=1;
          MPI_Offset start, count=1;
          char buf[13] = "Hello World\\n";
          int *data=NULL;

          MPI_Init(&argc, &argv);

          MPI_Comm_rank(MPI_COMM_WORLD, &rank);
          MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

          if (argc != 2) {
              if (rank == 0) printf("Usage: %s filename\\n", argv[0]);
              MPI_Finalize();
              exit(-1);
          }

          if (rank == 0) {
              ret = ncmpi_create(MPI_COMM_SELF, argv[1],
                                 NC_CLOBBER|NC_64BIT_OFFSET, MPI_INFO_NULL, &ncfile);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              ret = ncmpi_def_dim(ncfile, "d1", nprocs, &dimid);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              ret = ncmpi_def_var(ncfile, "v1", NC_INT, ndims, &dimid, &varid1);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              ret = ncmpi_def_var(ncfile, "v2", NC_INT, ndims, &dimid, &varid2);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              ret = ncmpi_put_att_text(ncfile, NC_GLOBAL, "string", 13, buf);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              ret = ncmpi_enddef(ncfile);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              /* first reason this approach is not scalable:  need to allocate
              * enough memory to hold data from all processors */
              data = (int*)calloc(nprocs, sizeof(int));
          }

          /* second reason this approach is not scalable: sending to rank 0
           * introduces a serialization point, even if using an optimized
           * collective routine */
          MPI_Gather(&rank, 1, MPI_INT, data, 1, MPI_INT, 0, MPI_COMM_WORLD);

          if (rank == 0) {
              /* and lastly, the third reason this approach is not scalable: I/O
               * happens from a single processor.  This approach can be ok if the
               * amount of data is quite small, but almost always the underlying
               * MPI-IO library can do a better job */
              start=0, count=nprocs;
              ret = ncmpi_put_vara_int_all(ncfile, varid1, &start, &count, data);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              ret = ncmpi_put_vara_int_all(ncfile, varid2, &start, &count, data);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              ret = ncmpi_close(ncfile);
              if (ret != NC_NOERR) handle_error(ret, __LINE__);

              free(data);
          }

          MPI_Finalize();
          return 0;
      }
    EOS
    (testpath/"output.expected").write <<-EOS.undent
    netcdf output {
    // file format: CDF-2 (large file)
    dimensions:
        d1 = 4 ;
    variables:
        int v1(d1) ;
        int v2(d1) ;

    // global attributes:
                :string = "Hello World\\n",
        "" ;
    data:

     v1 = 0, 1, 2, 3 ;

     v2 = 0, 1, 2, 3 ;
    }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    assert_match "version: 1.7", shell_output("./test")
    system "mpicc", "test_mpi.c", "-L#{lib}", "-I#{include}", "-lpnetcdf", "-o", "test"
    system "mpiexec", "-n", "4", "./test", "output.nc"
    assert File.exist?("output.nc")
    assert_match shell_output("#{bin}/ncmpidump output.nc > output.ncdump"), shell_output("cat output.expected")
  end
end
