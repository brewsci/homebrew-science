class Slepc < Formula
  desc "Scalable Library for Eigenvalue Computations"
  homepage "http://www.grycap.upv.es/slepc"
  url "http://slepc.upv.es/download/download.php?filename=slepc-3.6.0.tar.gz"
  sha256 "591e20d793c273ff12bf1cd4bee79c6c55203dd67ad62a3023f35f4d0ce248c6"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha256 "58641318a441a76650b33a2ae5771f407df53493686425b1610b934b626929c6" => :yosemite
    sha256 "c8f0b84f8870ddec53a2eae888fe298c3df39caff98fa75588fd42c609e46bdb" => :mavericks
    sha256 "887a1451913249737108f65903959ea46a049ef6b811d628e08b8eb4095abeeb" => :mountain_lion
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
    # TODO: investigate why complex tests fail to run on Linuxbrew
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
    (share/"slepc").install "share/slepc/datafiles"
  end

  def caveats; <<-EOS.undent
    Set your SLEPC_DIR to #{prefix}/real or #{prefix}/complex.
    Fortran modules are in #{prefix}/real/include and #{prefix}/complex/include.
    EOS
  end
end
