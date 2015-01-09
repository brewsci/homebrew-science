class Petsc < Formula
  homepage "http://www.mcs.anl.gov/petsc/index.html"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.2.tar.gz"
  sha1 "d60d1735762f2e398774514451e137580bb2c7bb"
  head "https://bitbucket.org/petsc/petsc", :using => :git
  revision 2

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 5
    sha1 "7fe6b8b1786b409604eda1eddf85070adf999237" => :yosemite
    sha1 "076a2960b19abcf84f9f1f95536f3d02863dddd0" => :mavericks
    sha1 "c423f0745cec7643ece8f82552557fb39b897d52" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"
  option "with-complex", "Link complex version of PETSc by default."
  option "with-debug", "Build debug version"

  deprecated_option "complex" => "with-complex"
  deprecated_option "debug"   => "with-debug"

  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran
  depends_on :x11 => :optional
  depends_on "cmake" => :build

  depends_on "openssl"
  depends_on "superlu"      => :recommended
  depends_on "superlu_dist" => :recommended
  depends_on "metis"        => :recommended
  depends_on "parmetis"     => :recommended
  depends_on "scalapack"    => :recommended
  depends_on "mumps"        => :recommended
  depends_on "hypre"        => ["with-mpi", :recommended]

  def oprefix(f)
    Formula[f].opt_prefix
  end

  def install
    ENV.deparallelize

    arch_real="real"
    arch_complex="complex"

    # Environment variables CC, CXX, etc. will be ignored by PETSc.
    ENV.delete "CC"
    ENV.delete "CXX"
    ENV.delete "F77"
    ENV.delete "FC"
    args = %W[CC=#{ENV["MPICC"]}
              CXX=#{ENV["MPICXX"]}
              F77=#{ENV["MPIF77"]}
              FC=#{ENV["MPIFC"]}
              --with-shared-libraries=1
           ]
    args << ("--with-debugging=" + ((build.with? "debug") ? "1" : "0"))

    if build.with? "superlu_dist"
      slud = Formula["superlu_dist"]
      args << "--with-superlu_dist-include=#{slud.opt_include}/superlu_dist"
      args << "--with-superlu_dist-lib=-L#{slud.opt_lib} -lsuperlu_dist"
    end

    if build.with? "superlu"
      slu = Formula["superlu"]
      args << "--with-superlu-include=#{slu.opt_include}/superlu"
      args << "--with-superlu-lib=-L#{slu.opt_lib} -lsuperlu"
    end

    args << "--with-metis-dir=#{oprefix("metis")}" if build.with? "metis"
    args << "--with-parmetis-dir=#{oprefix("parmetis")}" if build.with? "parmetis"
    args << "--with-scalapack-dir=#{oprefix("scalapack")}" if build.with? "scalapack"
    args << "--with-mumps-dir=#{oprefix("mumps")}" if build.with? "mumps"
    args << "--with-x=0" if build.without? "x11"

    # configure fails if those vars are set differently.
    ENV["PETSC_DIR"] = Dir.getwd

    # real-valued case:
    ENV["PETSC_ARCH"] = arch_real
    args_real = ["--prefix=#{prefix}/#{arch_real}",
                 "--with-scalar-type=real"]
    args_real << "--with-hypre-dir=#{oprefix("hypre")}" if build.with? "hypre"
    system "./configure", *(args + args_real)
    system "make", "all"
    system "make", "test" if build.with? "check"
    system "make", "install"

    # complex-valued case:
    ENV["PETSC_ARCH"] = arch_complex
    args_cmplx = ["--prefix=#{prefix}/#{arch_complex}",
                  "--with-scalar-type=complex"]
    system "./configure", *(args + args_cmplx)
    system "make", "all"
    system "make", "test" if build.with? "check"
    system "make", "install"

    # Link only what we want.
    petsc_arch = ((build.with? "complex") ? arch_complex : arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"],
                                "#{prefix}/#{petsc_arch}/include/finclude",
                                "#{prefix}/#{petsc_arch}/include/petsc-private"
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"],
                        Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
    share.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
  end

  def caveats; <<-EOS
    Set PETSC_DIR to #{prefix}/real or #{prefix}/complex.
    Fortran module files are in
      #{prefix}/real/include and #{prefix}/complex/include
    EOS
  end
end
