class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "http://lammps.sandia.gov"
  url "http://lammps.sandia.gov/tars/lammps-31Mar17.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY.MM.DD (year.month.day) so that we get a comparable version numbering (for brew outdated).
  # We only track "stable" releases as announced on the LAMMPS homepage.
  version "2017.03.31"
  sha256 "c90158833f99a823ce81b24d88abef2336a79e4966bd789443d2aa22cbb81cb9"
  revision 2
  head "http://git.icms.temple.edu/lammps-ro.git"
  # tag "chemistry"
  # doi "10.1006/jcph.1995.1039"

  bottle do
    cellar :any
    sha256 "3aa1bb54aebc945f5e4f59ff39332a59d6de3afad4e4f08cf868bc396b18daed" => :sierra
    sha256 "5bdc937d9d5c4a0b0ed0f4dfd5d0aeb846742b2a09f6c722f97caf69cbf7ee9c" => :el_capitan
    sha256 "3f5a62407e6a78609f5d7fa1d9daeff5ed573fb64f2a8e6a35502be100d06e61" => :yosemite
    sha256 "0883e439fc67da018852bd013e5ee8c648dd793bc63fb3ba5111473eab27750b" => :x86_64_linux
  end

  # user-submitted packages not considered "standard"
  USER_PACKAGES = %w[
    user-misc
    user-awpmd
    user-cg-cmm
    user-colvars
    user-eff
    user-molfile
    user-reaxc
    user-sph
  ].freeze

  # could not get gpu or user-cuda to install (hardware problem?)
  # kim requires openkim software, which is not currently in homebrew.
  # user-atc would not install without mpi and then would not link to blas-lapack
  # user-omp requires gcc dependency (tricky). clang does not have OMP support, yet.
  # mscg needs https://github.com/uchicago-voth/MSCG-release
  DISABLED_PACKAGES = %w[
    gpu
    kim
    user-omp
    kokkos
    mscg
  ].freeze
  DISABLED_USER_PACKAGES = %w[
    user-atc
    user-cuda
  ].freeze

  # setup user-packages as options
  USER_PACKAGES.each do |package|
    option "with-#{package}", "Build lammps with the '#{package}' package"
    deprecated_option "enable-#{package}" => "with-#{package}"
  end

  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "voro++"
  depends_on "zlib" unless OS.mac?
  depends_on :mpi => [:cxx, :f90, :recommended] # dummy MPI library provided in src/STUBS
  depends_on :fortran
  depends_on :python

  def build_lib(comp, lmp_lib, opts = {})
    change_compiler_var = opts[:change_compiler_var] # a non-standard compiler name to replace
    prefix_make_var = opts[:prefix_make_var] || "" # prepended to makefile variable names

    cd "lib/" + lmp_lib do
      if comp == "FC"
        make_file = "Makefile.gfortran" # make file
        compiler_var = "F90" # replace compiler
      elsif comp == "CXX"
        make_file = "Makefile.g++" # make file
        compiler_var = "CC" # replace compiler
      elsif comp == "MPICXX"
        make_file = "Makefile.openmpi" # make file
        compiler_var = "CC" # replace compiler
        comp = "CXX" unless ENV["MPICXX"]
      end
      compiler_var = change_compiler_var if change_compiler_var

      # force compiler
      inreplace make_file do |s|
        s.change_make_var! compiler_var, ENV[comp]
      end

      system "make", "-f", make_file

      if File.exist? "Makefile.lammps"
        # empty it to reduce chance of conflicts
        inreplace "Makefile.lammps" do |s|
          s.change_make_var! prefix_make_var + lmp_lib + "_SYSINC", ""
          s.change_make_var! prefix_make_var + lmp_lib + "_SYSLIB", ""
          s.change_make_var! prefix_make_var + lmp_lib + "_SYSPATH", ""
        end
      end
    end
  end

  def pyver
    Language::Python.major_minor_version "python"
  end

  def install
    ENV.deparallelize # not parallel safe (some packages have race conditions :meam:)

    if OS.mac?
      cd "lib/python" do
        inreplace ["Makefile.lammps", "Makefile.lammps.python2"],
          "python_SYSLIB = $(shell which python2-config > /dev/null 2>&1 && python2-config --ldflags || python-config --ldflags)",
          "python_SYSLIB = -ldl -framework CoreFoundation -undefined dynamic_lookup"
        inreplace "Makefile.lammps.python2.7",
          "python_SYSLIB = -lpython2.7 -lnsl -ldl -lreadline -ltermcap -lpthread -lutil -lm -Xlinker -export-dynamic",
          "python_SYSLIB = -undefined dynamic_lookup -lnsl -ldl -lreadline -ltermcap -lpthread -lutil -lm -Xlinker -export-dynamic"
      end
    end

    # make sure to optimize the installation
    ENV.append "CFLAGS", "-O"
    ENV.append "LDFLAGS", "-O"

    if build.with? :mpi
      # Simplify by relying on the mpi compilers
      ENV["FC"]  = ENV["MPIFC"]
      ENV["CXX"] = ENV["MPICXX"]
    end

    # build package libraries
    build_lib "FC",    "reax"
    build_lib "FC",    "meam"
    build_lib "CXX",   "poems"
    build_lib "CXX",   "colvars", :change_compiler_var => "CXX" if build.include? "enable-user-colvars"
    if build.include? "enable-user-awpmd"
      build_lib "MPICXX", "awpmd", :prefix_make_var => "user-"
      ENV.append "LDFLAGS", "-lblas -llapack"
    end

    # Locate gfortran library
    libgfortran = `$FC --print-file-name libgfortran.a`.chomp
    ENV.append "LDFLAGS", "-L#{File.dirname libgfortran} -lgfortran"

    # Locate zlib library for Linux
    ENV.append "LDFLAGS", "-lz -L#{Formula["zlib"].opt_prefix}/lib" unless OS.mac?

    inreplace "lib/voronoi/Makefile.lammps" do |s|
      s.change_make_var! "voronoi_SYSINC", "-I#{Formula["voro++"].opt_include}/voro++"
    end

    if OS.mac?
      makefile = "MAKE/MACHINES/Makefile.mac"
    else
      makefile = "MAKE/MACHINES/Makefile.ubuntu"
    end

    # build the lammps program and library
    cd "src" do
      # setup the make file variabls for fftw, jpeg, and mpi
      inreplace makefile do |s|
        # We will stick with "make mac" type and forget about
        # "make mac_mpi" because it has some unnecessary
        # settings. We get a nice clean slate with "mac"
        if build.with? :mpi
          #-DOMPI_SKIP_MPICXX is to speed up c++ compilation
          s.change_make_var! "MPI_INC",  "-DOMPI_SKIP_MPICXX"
          s.change_make_var! "MPI_PATH", ""
          s.change_make_var! "MPI_LIB",  ""
        end
        s.change_make_var! "CC",   ENV["CXX"]
        s.change_make_var! "LINK", ENV["CXX"]

        # installing with FFTW and JPEG
        s.change_make_var! "FFT_INC",  "-DFFT_FFTW3 -I#{Formula["fftw"].opt_prefix}/include"
        s.change_make_var! "FFT_PATH", "-L#{Formula["fftw"].opt_prefix}/lib"
        s.change_make_var! "FFT_LIB",  "-lfftw3"

        s.change_make_var! "JPG_INC",  "-DLAMMPS_JPEG -I#{Formula["jpeg"].opt_prefix}/include -DLAMMPS_PNG -I#{Formula["libpng"].opt_prefix}/include"
        s.change_make_var! "JPG_PATH", "-L#{Formula["jpeg"].opt_prefix}/lib -L#{Formula["libpng"].opt_prefix}/lib"
        s.change_make_var! "JPG_LIB",  "-ljpeg -lpng"

        s.change_make_var! "CCFLAGS",  ENV["CFLAGS"]
        s.change_make_var! "LIB",      ENV["LDFLAGS"]
      end

      # setup standard packages
      system "make", "yes-standard"
      DISABLED_PACKAGES.each do |pkg|
        system "make", "no-" + pkg
      end

      # setup optional packages
      USER_PACKAGES.each do |pkg|
        system "make", "yes-" + pkg if build.include? "enable-" + pkg
      end

      if build.without? :mpi
        # build fake mpi library
        cd "STUBS" do
          system "make"
        end
      end

      # build the lammps executable and library
      system "make", OS.mac? ? "mac" : "ubuntu"
      system "make", OS.mac? ? "mac" : "ubuntu", "mode=shlib"
      mv OS.mac? ? "lmp_mac" : "lmp_ubuntu", "lammps" # rename it to make it easier to find
    end

    # install the python module
    cd "python" do
      lib_site_packages = lib/"python#{pyver}/site-packages"
      mkdir_p lib_site_packages
      system "python", "install.py", lib_site_packages
      (lib_site_packages/"homebrew-lammps.pth").write (opt_lib/"python#{pyver}/site-packages").to_s
      mv "examples", "python-examples"
      pkgshare.install "python-examples"
    end

    bin.install "src/lammps"
    lib.install OS.mac? ? "src/liblammps_mac.so" : "src/liblammps_ubuntu.so"
    lib.install "src/liblammps.so" # this is just a soft-link to liblamps_mac|ubuntu.so
    pkgshare.install(%w[doc potentials tools bench examples])
  end

  def caveats
    <<-EOS.undent
    You should run a benchmark test or two. There are plenty available.

      cd #{HOMEBREW_PREFIX}/share/lammps/bench
      lammps -in in.lj
      # with mpi
      mpiexec -n 2 lammps -in in.lj

    The following directories could come in handy

      Documentation:
      #{HOMEBREW_PREFIX}/share/lammps/doc/Manual.html

      Potential files:
      #{HOMEBREW_PREFIX}/share/lammps/potentials

      Python examples:
      #{HOMEBREW_PREFIX}/share/lammps/python-examples

      Additional tools (may require manual installation):
      #{HOMEBREW_PREFIX}/share/lammps/tools

    To use the Python module with Python, you may need to amend your
    PYTHONPATH like:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python#{pyver}/site-packages:$PYTHONPATH

    EOS
  end

  test do
    system "#{bin}/lammps", "-in", "#{HOMEBREW_PREFIX}/share/lammps/bench/in.lj"
    system "python", "-c", "from lammps import lammps ; lammps().file('#{HOMEBREW_PREFIX}/share/lammps/bench/in.lj')"
  end
end
