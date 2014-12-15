require 'formula'

class Slepc < Formula
  homepage 'http://www.grycap.upv.es/slepc'
  url 'http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.5.2.tar.gz'
  sha1 '23675bee5c010d20f4a08f80f22120119ddb940a'
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "a6ec347ac8513518297e2e61e494e0b0f3d0916e" => :yosemite
    sha1 "6f18da0e8e9a2844f7568664bed437e8bc000674" => :mavericks
    sha1 "929c5863c88478a94f656f11e978cfbee318eb46" => :mountain_lion
  end

  option "complex", "Use complex version by default. Otherwise, real-valued version will be symlinked"

  depends_on 'petsc' => :build
  depends_on :mpi => [:cc, :f90]
  depends_on :fortran
  depends_on :x11  => :optional
  depends_on 'arpack' => [:recommended, "with-mpi"]

  def install
    ENV.deparallelize

    # these must be consistent with petsc.rb
    petsc_arch_real="real"
    petsc_arch_complex="complex"

    ENV['SLEPC_DIR'] = Dir.getwd
    args = %W[--with-clean=true]
    args << "--with-arpack-dir=#{Formula["arpack"].lib}" << "--with-arpack-flags=-lparpack,-larpack" if build.with? "arpack"

    # real
    ENV['PETSC_DIR'] = ("#{Formula["petsc"].opt_prefix}" +"/"+petsc_arch_real)
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_real}", *args
    system "make"
    system "make test"
    system "make install"

    # complex
    ENV['PETSC_DIR'] = ("#{Formula["petsc"].opt_prefix}" +"/"+petsc_arch_complex)
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_complex}", *args
    system "make"
    system "make test"
    system "make install"

    ohai 'Test results are in ~/Library/Logs/Homebrew/slepc. Please check.'

    # Link what we need.
    petsc_arch = ((build.include? "complex") ? petsc_arch_complex : petsc_arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"], "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install 'docs/slepc.pdf', Dir["docs/*.htm"], 'docs/manualpages'  # They're not really man pages.
    share.install 'share/slepc/datafiles'
  end

  def caveats; <<-EOS.undent
    Set your SLEPC_DIR to #{prefix}/real or #{prefix}/complex.
    Fortran modules are in #{prefix}/real/include and #{prefix}/complex/include.
    EOS
  end
end
