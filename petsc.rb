require "formula"

class Petsc < Formula
  homepage "http://www.mcs.anl.gov/petsc/index.html"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.5.2.tar.gz"
  sha1 "d60d1735762f2e398774514451e137580bb2c7bb"
  head "https://bitbucket.org/petsc/petsc", :using => :git

  option "without-check", "Skip build-time tests (not recommended)"
  option "complex", "Use complex version by default. Otherwise, real-valued version will be symlinked"
  option "debug", "Compile debug version"

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
  depends_on "hypre"        => :optional  #compile error here

  def install
    ENV.deparallelize

    petsc_arch_real="real"
    petsc_arch_complex="complex"

    args = %W[
      --with-shared-libraries=1
    ]
    args << ( (build.include? "debug") ? "--with-debugging=1" : "--with-debugging=0" )

    args << "--with-superlu_dist-include=#{Formula["superlu_dist"].include}/superlu_dist" << "--with-superlu_dist-lib=#{Formula["superlu_dist"].lib}/libsuperlu_dist.a" if build.with? "superlu_dist"
    args << "--with-metis-dir=#{Formula["metis"].prefix}" if build.with? "metis"
    args << "--with-parmetis-dir=#{Formula["parmetis"].prefix}" if build.with? "parmetis"
    args << "--with-scalapack-dir=#{Formula["scalapack"].prefix}" if build.with? "scalapack"
    args << "--with-mumps-dir=#{Formula["mumps"].prefix}" if build.with? "mumps"
    args << "--with-x=0" if build.without? "x11"

    ENV["PETSC_DIR"] = Dir.getwd  # configure fails if those vars are set differently.

    # real-valued case:
    ENV["PETSC_ARCH"] = petsc_arch_real
    args_real = ["--prefix=#{prefix}/#{petsc_arch_real}", "--with-scalar-type=real"]
    args_real << "--with-hypre-dir=#{Formula["hypre"].prefix}" if build.with? "hypre"
    system "./configure", *(args + args_real)
    system "make all"
    system "make test" if build.with? "check"
    system "make install"

    # complex-valued case:
    ENV["PETSC_ARCH"] = petsc_arch_complex
    args_cmplx = ["--prefix=#{prefix}/#{petsc_arch_complex}", "--with-scalar-type=complex"]
    system "./configure", *(args + args_cmplx)
    system "make all"
    system "make test" if build.with? "check"
    system "make install"

    # Link only what we want.
    petsc_arch = ((build.include? "complex") ? petsc_arch_complex : petsc_arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*h"], "#{prefix}/#{petsc_arch}/include/finclude", "#{prefix}/#{petsc_arch}/include/petsc-private"
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
    share.install_symlink Dir["#{prefix}/#{petsc_arch}/share/*"]
  end

  def caveats; <<-EOS
    Set PETSC_DIR to #{prefix}/real or #{prefix}/complex.
    Fortran module files are in #{prefix}/real/include and #{prefix}/complex/include
    EOS
  end
end
