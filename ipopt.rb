require 'formula'

class Ipopt < Formula
  homepage 'https://projects.coin-or.org/Ipopt'
  url 'http://www.coin-or.org/download/source/Ipopt/Ipopt-3.11.9.tgz'
  sha1 '1bc6db565e5fb1ecbc40ff5179eab8409ba92b07'
  head 'https://projects.coin-or.org/svn/Ipopt/trunk', :using => :svn
  revision 1

  option 'without-check', 'Skip build-time tests (not recommended)'

  depends_on 'asl' => :recommended
  depends_on 'openblas' => :optional
  depends_on 'pkg-config' => :build
  depends_on 'mumps' => (build.with? 'openblas') ? ['with-openblas'] : :build

  depends_on :fortran

  def mumps_options
    Tab.for_formula(Formula["mumps"])
  end

  def install
    ENV.delete('MPICC')  # configure will pick these up and use them to link
    ENV.delete('MPIFC')  # which leads to the linker crashing.
    ENV.delete('MPICXX')
    mumps_libs = %w[-ldmumps -lmumps_common -lpord]

    # See whether the parallel or sequential MUMPS library was built.
    if mumps_options.without? "mpi"
      mumps_libs << '-lmpiseq'
      mumps_incdir = Formula["mumps"].libexec / 'include'
    else
      # The MPI libs were installed as a MUMPS dependency.
      mumps_libs += %w[-lmpi_cxx -lmpi_mpifh]
      mumps_incdir = Formula["mumps"].opt_include
      ENV.append_to_cflags "-DHAVE_MPI_INITIALIZED"  # Mumps initializes MPI.
    end
    mumps_libcmd = "-L#{Formula["mumps"].opt_lib} " + mumps_libs.join(' ')

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-mumps-incdir=#{mumps_incdir}",
            "--with-mumps-lib=#{mumps_libcmd}",
            "--enable-shared",
            "--enable-static"]

    if build.with? 'openblas'
      args << "--with-blas-incdir=#{Formula["openblas"].opt_include}"
      args << "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas"
      args << "--with-lapack-incdir=#{Formula["openblas"].opt_include}"
      args << "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas"
    end

    if build.with? 'asl'
      args << "--with-asl-incdir=#{Formula["asl"].opt_include}/asl"
      args << "--with-asl-lib=-L#{Formula["asl"].opt_lib} -lasl -lfuncadd0"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make test" if build.with? "check"
    system "make install"
  end
end

