class Slepc < Formula
  desc "Scalable Library for Eigenvalue Computations"
  homepage "http://www.grycap.upv.es/slepc"
  url "http://slepc.upv.es/download/download.php?filename=slepc-3.7.3.tar.gz"
  sha256 "3ef9bcc645a10c1779d56b3500472ceb66df692e389d635087d30e7c46424df9"
  revision 2

  bottle do
    sha256 "3424419ef686b7f47a7de8ed00b79416fa103b7c64fd42c15c9b991be81ac96d" => :sierra
    sha256 "4095a9ba6709d2bcdc922e76056ad5915dabaa0365b900a0a9e740f49cc7a551" => :el_capitan
    sha256 "8cf38a4ec7869fe43ae8385933b70e1b8927e5cd0196b55a8af47a4ab2889efe" => :yosemite
  end

  deprecated_option "complex" => "with-complex"

  option "with-complex", "Use complex version by default. Otherwise, real-valued version will be symlinked"
  option "without-test", "Skip run-time tests (not recommended)"
  option "with-openblas", "Install dependencies with openblas"
  option "with-blopex", "Download blopex library"

  deprecated_option "without-check" => "without-test"

  openblasdep = (build.with? "openblas") ? ["with-openblas"] : []

  depends_on "petsc" => openblasdep
  depends_on :mpi => [:cc, :f90]
  depends_on :fortran
  depends_on "hdf5"
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
    system "make", "test" if build.with? "test"
    system "make", "install"

    # complex
    ENV["PETSC_DIR"] = "#{Formula["petsc"].opt_prefix}/#{petsc_arch_complex}"
    system "./configure", "--prefix=#{prefix}/#{petsc_arch_complex}", *args
    system "make"
    # TODO: investigate why complex tests fail to run on Linuxbrew
    system "make", "test" if build.with? "test"
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
      `cat ex1.out | tail -3 | awk '{print $NF}'`.split.each do |val|
        assert val.to_f < 1.0e-8
      end
    end
  end
end
