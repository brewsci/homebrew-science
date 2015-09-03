class Slepc < Formula
  desc "Scalable Library for Eigenvalue Computations"
  homepage "http://www.grycap.upv.es/slepc"
  url "http://slepc.upv.es/download/download.php?filename=slepc-3.6.1.tar.gz"
  sha256 "c0a3997347144b145ec6f783feadc5021428f05a965c3f285b2dafa9f84eb8a6"

  bottle do
    revision 1
    sha256 "823e18041b352030cebcab43a7e4d40da1a78f02156f179996f67a4f45e7d88f" => :yosemite
    sha256 "0f18fdda9eea67e2d662451fc277d02ad50c84a613a0f188587b45657e48a168" => :mavericks
    sha256 "e46cb03c3177ba2aee58eb9a4361822e160698df3b79f2f9dcae531e3d2f9d7c" => :mountain_lion
  end

  deprecated_option "complex" => "with-complex"

  option "with-complex", "Use complex version by default. Otherwise, real-valued version will be symlinked"
  option "without-check", "Skip run-time tests (not recommended)"
  option "with-openblas", "Install dependencies with openblas"

  openblasdep = (build.with? "openblas") ? ["with-openblas"] : []

  depends_on "petsc" => [:build] + openblasdep
  depends_on :mpi => [:cc, :f90]
  depends_on :fortran
  depends_on :x11 => :optional
  depends_on "arpack" => [:recommended, "with-mpi"] + openblasdep

  def install
    ENV.deparallelize

    # these must be consistent with petsc.rb
    petsc_arch_real = "real"
    petsc_arch_complex = "complex"

    ENV["SLEPC_DIR"] = Dir.getwd
    args = ["--with-clean=true"]
    args << "--with-arpack-dir=#{Formula["arpack"].lib}" << "--with-arpack-flags=-lparpack,-larpack" if build.with? "arpack"

    # real
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{petsc_arch_real}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_real}", *args
    system "make"
    system "make", "test" if build.with? "check"
    system "make", "install"

    # complex
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{petsc_arch_complex}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_complex}", *args
    system "make"
    # TODO: investigate why complex tests fail to run on Linuxbrew
    system "make", "test" if build.with? "check"
    system "make", "install"

    ohai "Test results are in ~/Library/Logs/Homebrew/slepc. Please check."

    # Link what we need.
    petsc_arch = ((build.include? "complex") ? petsc_arch_complex : petsc_arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"],
                            "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install "docs/slepc.pdf", Dir["docs/*.htm"], "docs/manualpages" # They're not really man pages.
    pkgshare.install "share/slepc/datafiles"
  end

  def caveats; <<-EOS.undent
    Set your SLEPC_DIR to #{prefix}/real or #{prefix}/complex.
    Fortran modules are in #{prefix}/real/include and #{prefix}/complex/include.
    EOS
  end
end
