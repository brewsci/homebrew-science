class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org"
  url "https://downloads.sourceforge.net/project/cp2k/cp2k-4.1.tar.bz2"
  sha256 "4a3e4a101d8a35ebd80a9e9ecb02697fb8256364f1eccdbe4e5a85d31fe21343"
  head "https://svn.code.sf.net/p/cp2k/code/trunk"
  # tag "chemistry"
  # doi "10.1016/j.cpc.2004.12.014"

  bottle do
    sha256 "4cc1d9167370d0c3ae59ffce5be9fbdb0f7e905f448916fd5219c8ff00779d6d" => :sierra
    sha256 "378604335f111cb66501f3465f000bce8608f577a68ce0efae2065d170b5750e" => :el_capitan
    sha256 "f2249e0a6c7cc344855e489549ec3ce06d8d7bb0e3b7c1ac9b4cbd37409e5f4c" => :yosemite
  end

  depends_on :fortran
  depends_on "gcc"
  depends_on "fftw" => "with-fortran"
  depends_on "libxc"
  needs :openmp
  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on "scalapack"

  resource "libint" do
    url "https://downloads.sourceforge.net/project/libint/v1-releases/libint-1.1.5.tar.gz"
    sha256 "31d7dd553c7b1a773863fcddc15ba9358bdcc58f5962c9fcee1cd24f309c4198"
  end

  def install
    resource("libint").stage do
      system "./configure", "--prefix=#{prefix}/dependencies"
      system "make"
      system "make", "install"
    end

    # SVN repo has different layout than released versions
    cd "cp2k" if build.head?

    # CP2K configuration is done through editing of arch files
    dflags = "-D__LIBXC -D__FFTW3 -D__LIBINT"
    fcflags = "-I#{Formula["libxc"].opt_prefix}/include -I#{Formula["fftw"].opt_prefix}/include -I#{prefix}/dependencies/include"
    libs = "-L#{Formula["libxc"].opt_prefix}/lib -lxcf90 -lxc -L#{prefix}/dependencies/lib -lderiv -lint -L#{Formula["fftw"].opt_prefix}/lib -lfftw3"

    inreplace "arch/Darwin-IntelMacintosh-gfortran.sopt", /DFLAGS *=/, "DFLAGS = #{dflags}"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.sopt", /FCFLAGS *=/, "FCFLAGS = #{fcflags}"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.sopt", /LIBS *=/, "LIBS = #{libs}"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.ssmp", /DFLAGS *=/, "DFLAGS = #{dflags}"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.ssmp", /FCFLAGS *=/, "FCFLAGS = #{fcflags}"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.ssmp", /LIBS *=/, "LIBS = #{libs} -lfftw3_threads"

    # CP2K does not provide a parallel arch file for Darwin, so we create our own
    cp "arch/Darwin-IntelMacintosh-gfortran.sopt", "arch/Darwin-IntelMacintosh-gfortran.popt"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.popt", /FC *= gfortran/, "FC = mpif90"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.popt", /LD *= gfortran/, "LD = mpif90"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.popt", /DFLAGS *=/, "DFLAGS = -D__MPI_VERSION=3 -D__parallel -D__SCALAPACK"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.popt", /LIBS *=/, "LIBS = -L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"

    # MPI + OpenMP version
    cp "arch/Darwin-IntelMacintosh-gfortran.popt", "arch/Darwin-IntelMacintosh-gfortran.psmp"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.psmp", /FCFLAGS *=/, "FCFLAGS = -fopenmp"
    inreplace "arch/Darwin-IntelMacintosh-gfortran.psmp", /LIBS *=/, "LIBS = -lfftw3_threads"

    # Now we build
    cd "makefiles" do
      system "make", "ARCH=Darwin-IntelMacintosh-gfortran", "VERSION=sopt"
      system "make", "ARCH=Darwin-IntelMacintosh-gfortran", "VERSION=ssmp"
      system "make", "ARCH=Darwin-IntelMacintosh-gfortran", "VERSION=popt"
      system "make", "ARCH=Darwin-IntelMacintosh-gfortran", "VERSION=psmp"
    end

    # Install binaries
    ["sopt", "ssmp", "popt", "psmp"].each do |exe|
      bin.install "exe/Darwin-IntelMacintosh-gfortran/cp2k.#{exe}"
      bin.install "exe/Darwin-IntelMacintosh-gfortran/cp2k_shell.#{exe}"
    end

    # Install test file
    (prefix/"tests").install "tests/Fist/water512.inp"
  end

  test do
    system "#{bin}/cp2k.sopt", "#{prefix}/tests/water512.inp"
    system "#{bin}/cp2k.ssmp", "#{prefix}/tests/water512.inp"
    system "mpirun", "-np", "4", "#{bin}/cp2k.popt", "#{prefix}/tests/water512.inp"
    system "mpirun", "-np", "4", "#{bin}/cp2k.psmp", "#{prefix}/tests/water512.inp"
  end
end
