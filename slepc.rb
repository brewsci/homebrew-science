class Slepc < Formula
  homepage "http://www.grycap.upv.es/slepc"
  url "http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.5.3.tar.gz"
  sha1 "5e886c5018dc0d227ae815feb80d4cdd8779c23c"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 2
    sha256 "bf72a2180f2661826705fea7c6fdedfe34e38c3949b651109cc52a32534f4cdd" => :yosemite
    sha256 "57d505880bd7f126339d77b4b9e1d30ae0e831d836cf61fe94a74b2a5f43b449" => :mavericks
    sha256 "205719a3bdff239c77616580cc57e276ede3e35bdf8144e560b2beb34c10709a" => :mountain_lion
  end

  deprecated_option "complex" => "with-complex"

  option "with-complex", "Use complex version by default. Otherwise, real-valued version will be symlinked"
  option "without-check", "Skip run-time tests (not recommended)"

  depends_on "petsc" => :build
  depends_on :mpi => [:cc, :f90]
  depends_on :fortran
  depends_on :x11  => :optional
  depends_on "arpack" => [:recommended, "with-mpi"]

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
    # TODO investigate why complex tests fail to run on Linuxbrew
    system "make", "test"  if build.with? "check"
    system "make", "install"

    ohai "Test results are in ~/Library/Logs/Homebrew/slepc. Please check."

    # Link what we need.
    petsc_arch = ((build.include? "complex") ? petsc_arch_complex : petsc_arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"],
                            "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install "docs/slepc.pdf", Dir["docs/*.htm"], "docs/manualpages"  # They're not really man pages.
    share.install "share/slepc/datafiles"
  end

  def caveats; <<-EOS.undent
    Set your SLEPC_DIR to #{prefix}/real or #{prefix}/complex.
    Fortran modules are in #{prefix}/real/include and #{prefix}/complex/include.
    EOS
  end
end
