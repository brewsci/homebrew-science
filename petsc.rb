class Petsc < Formula
  homepage "http://www.mcs.anl.gov/petsc/index.html"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.2.tar.gz"
  sha1 "d60d1735762f2e398774514451e137580bb2c7bb"
  head "https://bitbucket.org/petsc/petsc", :using => :git
  revision 2

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 3
    sha1 "eca21013920e452254a4561a9fc82d6bc811616f" => :yosemite
    sha1 "9ca6c766b50a95a025924682e6a2972fd28ff6d4" => :mavericks
    sha1 "2984435e4b2f7c43fa62fc61295adbf89a7cebe5" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"
  option "with-complex", "Link complex version of PETSc by default."
  option "with-debug", "Build debug version"

  deprecated_option "complex" => "with-complex"
  deprecated_option "debug"   => "with-debug"

  depends_on :mpi => :cc
  depends_on :fortran
  depends_on :x11 => :optional
  depends_on "cmake" => :build

  depends_on "openssl"
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

    args = %w[
      --with-shared-libraries=1
    ]
    args << ("--with-debugging=" + ((build.with? "debug") ? "1" : "0"))

    if build.with? "superlu_dist"
      slu = Formula["superlu_dist"]
      args << "--with-superlu_dist-include=#{slu.opt_include}/superlu_dist"
      args << "--with-superlu_dist-lib=-L#{slu.opt_lib} -lsuperlu_dist"
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
