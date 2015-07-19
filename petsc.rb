class Petsc < Formula
  desc "Scalable (parallel) solution of scientific applications modeled by partial differential equations"
  homepage "http://www.mcs.anl.gov/petsc/index.html"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.6.0.tar.gz"
  sha256 "46e44b56f9f163e692c71b35f5d6b9b6746ab3484b7c4879d0f3eb475d98f053"
  head "https://bitbucket.org/petsc/petsc", :using => :git

  bottle do
    sha256 "abded28948a8317abe1211b87c958de5ff4ee5c10e6e25c4a79591f843cebfe9" => :yosemite
    sha256 "4cc16d34a473f0c6c5e4f0d724cedc2d9c1bd86ddad71b45dde5f29b5d04ed92" => :mavericks
    sha256 "3e80dcbab8d0fc3fae103aa6cf80daf499afd006cfeb56b467478b105c029067" => :mountain_lion
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

  depends_on "superlu"      => :recommended
  depends_on "superlu_dist" => :recommended
  depends_on "metis"        => :recommended
  depends_on "parmetis"     => :recommended
  depends_on "scalapack"    => :recommended
  depends_on "mumps"        => :recommended # mumps is built with mpi by default
  depends_on "hypre"        => ["with-mpi", :recommended]
  depends_on "sundials"     => ["with-mpi", :recommended]
  depends_on "hdf5"         => ["with-mpi", :recommended]
  depends_on "hwloc"        => :recommended
  depends_on "suite-sparse" => :recommended
  depends_on "netcdf"       => ["with-fortran", :recommended]
  depends_on "fftw"         => ["with-mpi", "with-fortran", :recommended]
  depends_on "openblas"     => :optional

  # TODO: add ML, YAML dependencies when the formulae are available

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

    # We don't dowload anything, don't need to build against openssl
    args << "--with-ssl=0"

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

    args << "--with-fftw-dir=#{oprefix("fftw")}" if build.with? "fftw"
    args << "--with-netcdf-dir=#{oprefix("netcdf")}" if build.with? "netcdf"
    args << "--with-suitesparse-dir=#{oprefix("suite-sparse")}" if build.with? "suite-sparse"
    args << "--with-hdf5-dir=#{oprefix("hdf5")}" if build.with? "hdf5"
    args << "--with-metis-dir=#{oprefix("metis")}" if build.with? "metis"
    args << "--with-parmetis-dir=#{oprefix("parmetis")}" if build.with? "parmetis"
    args << "--with-scalapack-dir=#{oprefix("scalapack")}" if build.with? "scalapack"
    args << "--with-mumps-dir=#{oprefix("mumps")}" if build.with? "mumps"
    args << "--with-x=0" if build.without? "x11"

    # if build with openblas, need to provide lapack as well.
    if build.with? "openblas"
      exten = (OS.mac?) ? "dylib" : "so"
      args << ("--with-blas-lib=#{Formula["openblas"].opt_lib}/libopenblas.#{exten}")
      args << ("--with-lapack-lib=#{Formula["openblas"].opt_lib}/libopenblas.#{exten}")
    end

    # configure fails if those vars are set differently.
    ENV["PETSC_DIR"] = Dir.getwd

    # real-valued case:
    ENV["PETSC_ARCH"] = arch_real
    args_real = ["--prefix=#{prefix}/#{arch_real}",
                 "--with-scalar-type=real"]
    args_real << "--with-hypre-dir=#{oprefix("hypre")}" if build.with? "hypre"
    args_real << "--with-sundials-dir=#{oprefix("sundials")}" if build.with? "sundials"
    args_real << "--with-hwloc-dir=#{oprefix("hwloc")}" if build.with? "hwloc"
    system "./configure", *(args + args_real)
    system "make", "all"
    if build.with? "check"
      log_name = "make-check-" + arch_real + ".log"
      system "make test 2>&1 | tee #{log_name}"
      ohai `grep "Completed test examples" "#{log_name}"`.chomp
      prefix.install "#{log_name}"
    end
    system "make", "install"

    # complex-valued case:
    ENV["PETSC_ARCH"] = arch_complex
    args_cmplx = ["--prefix=#{prefix}/#{arch_complex}",
                  "--with-scalar-type=complex"]
    system "./configure", *(args + args_cmplx)
    system "make", "all"
    if build.with? "check"
      log_name = "make-check-" + arch_complex + ".log"
      system "make test 2>&1 | tee #{log_name}"
      ohai `grep "Completed test examples" "#{log_name}"`.chomp
      prefix.install "#{log_name}"
    end
    system "make", "install"

    # Link only what we want.
    petsc_arch = ((build.with? "complex") ? arch_complex : arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"],
                                "#{prefix}/#{petsc_arch}/include/finclude",
                                "#{prefix}/#{petsc_arch}/include/petsc-private"
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    # symlink only files (don't symlink pkgconfig as it won't symlink to opt/lib)
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    (share/"petsc").install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
  end

  def caveats; <<-EOS
    Set PETSC_DIR to #{prefix}/real or #{prefix}/complex.
    Fortran module files are in
      #{prefix}/real/include and #{prefix}/complex/include
    EOS
  end
end
