require 'formula'

class Slepc < Formula
  homepage 'http://www.grycap.upv.es/slepc'
  url 'http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.4.4.tar.gz'
  sha1 'd7c09f3e2bb8910758e488e84c16a6eb266cf379'

  depends_on 'petsc' => :build
  depends_on :mpi => [:cc, :f90]
  depends_on :fortran
  depends_on :x11  => MacOS::X11.installed? ? :recommended : :optional

  # Trick SLEPc into thinking we don't have a prefix install of PETSc.
  def patches
    DATA
  end

  def install
    ENV.deparallelize
    petsc_arch = 'arch-darwin-c-opt'
    ENV['SLEPC_DIR'] = Dir.getwd
    ENV['PETSC_DIR'] = Formula["petsc"].prefix
    ENV['PETSC_ARCH'] = petsc_arch
    system "./configure", "--prefix=#{prefix}/#{petsc_arch}"
    system "make PETSC_ARCH=#{petsc_arch}"
    system "make PETSC_ARCH=#{petsc_arch} install"
    ENV['PETSC_ARCH'] = ''
    system "make SLEPC_DIR=#{prefix}/#{petsc_arch} test"
    ohai 'Test results are in ~/Library/Logs/Homebrew/slepc. Please check.'

    # Link what we need.
    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"], "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.a"], Dir["#{prefix}/#{petsc_arch}/lib/*.dylib"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install 'docs/slepc.pdf', Dir["docs/*.htm"], 'docs/manualpages'  # They're not really man pages.
    share.install 'share/slepc/datafiles'
  end

  def caveats; <<-EOS.undent
    Set your SLEPC_DIR to #{prefix}/arch-darwin-c-opt.
    Fortran modules are in #{prefix}/arch-darwin-c-opt/include.
    EOS
  end
end

__END__
diff --git a/config/configure.py b/config/configure.py
index 7d2fd64..22351c3 100755
--- a/config/configure.py
+++ b/config/configure.py
@@ -208,8 +208,6 @@ if petscversion.VERSION < slepcversion.VERSION:
 petscconf.Load(petscdir)
 if not petscconf.PRECISION in ['double','single','__float128']:
   sys.exit('ERROR: This SLEPc version does not work with '+petscconf.PRECISION+' precision')
-if prefixinstall and not petscconf.ISINSTALL:
-  sys.exit('ERROR: SLEPc cannot be configured for non-source installation if PETSc is not configured in the same way.')

 # Check whether this is a working copy of the repository
 isrepo = 0

