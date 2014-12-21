require 'formula'

class Slepc < Formula
  homepage 'http://www.grycap.upv.es/slepc'
  url 'http://www.grycap.upv.es/slepc/download/download.php?filename=slepc-3.5.3.tar.gz'
  sha1 '5e886c5018dc0d227ae815feb80d4cdd8779c23c'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "a4ef9c97bbaa9c9448e501bdeabaa17e82d8bd06" => :yosemite
    sha1 "0bd9fe0ebe8acc4402595428d201189dbd7b4633" => :mavericks
    sha1 "f1af93dee89952b511eb2b765a157c1c4b5870ed" => :mountain_lion
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
