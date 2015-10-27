class Slepc < Formula
  desc "Scalable Library for Eigenvalue Computations"
  homepage "http://www.grycap.upv.es/slepc"
  url "http://slepc.upv.es/download/download.php?filename=slepc-3.6.2.tar.gz"
  sha256 "2ab4311bed26ccf7771818665991b2ea3a9b15f97e29fd13911ab1293e8e65df"

  bottle do
    sha256 "707c11d73e213a83c5033159eb767b819eee9056f965a99c0d87fca0a549bf8f" => :yosemite
    sha256 "2f37b384325938f06e8f24ff7b3b0f2b6010890963d91a2767ba6a6fedad2875" => :mavericks
    sha256 "9b46fea66ae5e0eac564f8496381044ef5a2dde56f90d0be39ad379ca6cff3c1" => :mountain_lion
  end

  deprecated_option "complex" => "with-complex"

  option "with-complex", "Use complex version by default. Otherwise, real-valued version will be symlinked"
  option "without-check", "Skip run-time tests (not recommended)"
  option "with-openblas", "Install dependencies with openblas"
  option "with-blopex", "Download blopex library"

  openblasdep = (build.with? "openblas") ? ["with-openblas"] : []

  depends_on "petsc" => openblasdep
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
    args << "--with-arpack-dir=#{Formula["arpack"].opt_lib}" << "--with-arpack-flags=-lparpack,-larpack" if build.with? "arpack"
    args << "--download-blopex" if build.with? "blopex"

    # real
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{petsc_arch_real}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_real}", *args
    system "make"
    if build.with? "check"
      log_name = "make-test-real.log"
      system "make test 2>&1 | tee #{log_name}"
      ohai `grep "Completed test" "#{log_name}"`.chomp
      prefix.install "#{log_name}"
    end

    system "make", "test" if build.with? "check"
    system "make", "install"

    # complex
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{petsc_arch_complex}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_complex}", *args
    system "make"
    # TODO: investigate why complex tests fail to run on Linuxbrew
    if build.with? "check"
      log_name = "make-test-complex.log"
      system "make test 2>&1 | tee #{log_name}"
      ohai `grep "Completed test" "#{log_name}"`.chomp
      prefix.install "#{log_name}"
    end
    system "make", "install"

    # Link what we need.
    petsc_arch = ((build.include? "complex") ? petsc_arch_complex : petsc_arch_real)

    include.install_symlink Dir["#{prefix}/#{petsc_arch}/include/*.h"],
                            "#{prefix}/#{petsc_arch}/finclude", "#{prefix}/#{petsc_arch}/slepc-private"
    lib.install_symlink Dir["#{prefix}/#{petsc_arch}/lib/*.*"]
    prefix.install_symlink "#{prefix}/#{petsc_arch}/conf"
    doc.install "docs/slepc.pdf", Dir["docs/*.htm"], "docs/manualpages" # They're not really man pages.
    pkgshare.install "share/slepc/datafiles"

    # install some tutorials for use in test block
    pkgshare.install "src/eps/examples/tutorials"

    # fix install name on OS-X
    system "install_name_tool", "-id", "#{opt_prefix}/lib/libslepc.3.6.dylib", "#{prefix}/#{petsc_arch}/lib/libslepc.3.6.2.dylib" if OS.mac?
  end

  def caveats; <<-EOS.undent
    Set your SLEPC_DIR to #{opt_prefix}/real or #{opt_prefix}/complex.
    Fortran modules are in #{opt_prefix}/real/include and #{opt_prefix}/complex/include.
    EOS
  end

  test do
    cp_r prefix/"share/slepc/tutorials", testpath
    Dir.chdir("tutorials") do
      system "mpicc", "ex1.c", "-I#{opt_include}", "-I#{Formula["petsc"].opt_include}", "-L#{Formula["petsc"].opt_lib}", "-lpetsc", "-L#{opt_lib}", "-lslepc", "-o", "ex1"
      system "mpirun -np 3 ex1 2>&1 | tee ex1.out"
      assert (identical?("output/ex1_1.out", "ex1.out"))
    end
  end
end
