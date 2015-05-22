class Slepc < Formula
  homepage "http://www.grycap.upv.es/slepc"
  url "http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.5.3.tar.gz"
  sha1 "5e886c5018dc0d227ae815feb80d4cdd8779c23c"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "0156aaee48483d6cb32266a848e53bf06fd6c7a28116c793cd3083110b047c97" => :yosemite
    sha256 "6390bf1e2c95ed6a826d91566d73b99891faf7029fdb1b52fc0c64c41ad949bf" => :mavericks
    sha256 "56f492a173528edb6f1786e78294ac06846f3d53d073a51cc578a42d3354b394" => :mountain_lion
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
