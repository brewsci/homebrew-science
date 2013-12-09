require 'formula'

class Ipopt < Formula
  homepage 'https://projects.coin-or.org/Ipopt'
  url 'http://www.coin-or.org/download/source/Ipopt/Ipopt-3.11.5.tgz'
  sha1 '66e3ae03179ba7541a478d185b256f336159fc6d'

  depends_on 'asl' => :recommended
  depends_on 'openblas' => :optional
  depends_on 'pkg-config' => :build
  depends_on 'mumps' => (build.with? 'openblas') ? ['with-openblas'] : :build

  depends_on :fortran

  def install
    mumps_libs = ['-ldmumps', '-lmumps_common', '-lpord']

    # See whether the parallel or sequential MUMPS library was built.
    opts = Tab.for_formula(Formula.factory('mumps'))
    if opts.used_options.include? 'without-mpi'
      mumps_libs << '-lmpiseq'
      mumps_incdir = Formula.factory('mumps').libexec/'include'
    else
      # The MPI libs were installed as a MUMPS dependency.
      mumps_libs += ['-lmpi_cxx', '-lmpi_mpifh']
      mumps_incdir = Formula.factory('mumps').include
    end
    mumps_libcmd = "-L#{Formula.factory('mumps').lib} " + mumps_libs.join(' ')

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-mumps-incdir=#{mumps_incdir}",
            "--with-mumps-lib=#{mumps_libcmd}",
            "--enable-shared",
            "--enable-static"]

    if build.with? 'openblas'
      args << "--with-blas-incdir=#{Formula.factory('openblas').include}"
      args << "--with-blas-lib=-L#{Formula.factory('openblas').lib} -lopenblas"
      args << "--with-lapack-incdir=#{Formula.factory('openblas').include}"
      args << "--with-lapack-lib=-L#{Formula.factory('openblas').lib} -lopenblas"
    end

    if build.with? 'asl'
      args << "--with-asl-incdir=#{Formula.factory('asl').include}/asl"
      args << "--with-asl-lib=-L#{Formula.factory('asl').lib} -lasl -lfuncadd0"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make test"
    system "make install"
  end
end
