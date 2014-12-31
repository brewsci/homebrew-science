require "formula"

class Lammps < Formula
  homepage "http://lammps.sandia.gov"
  url "http://lammps.sandia.gov/tars/lammps-12Feb14.tar.gz"
  sha1 "2572cce8343862c32c6e4079b91a26637ae3c6b7"
  # lammps releases are named after their release date. We transform it to
  # YYYY.MM.DD (year.month.day) so that we get a comparable version numbering (for brew outdated)
  version "2014.02.12"

  head "http://git.icms.temple.edu/lammps-ro.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "72629a4467093ed32219bb07b4054ef953e0bbe2" => :yosemite
    sha1 "bfbe5d50c2d8c50af1096f1340fc2d59424844db" => :mavericks
    sha1 "cbadc5b55aaae6614bd06d2f67d0badf5bf68a22" => :mountain_lion
  end

  # user-submitted packages not considered "standard"
  USER_PACKAGES = %w(
    user-misc
    user-awpmd
    user-cg-cmm
    user-colvars
    user-eff
    user-molfile
    user-reaxc
    user-sph
  )

  # could not get gpu or user-cuda to install (hardware problem?)
  # kim requires openkim software, which is not currently in homebrew.
  # user-atc would not install without mpi and then would not link to blas-lapack
  # user-omp requires gcc dependency (tricky). clang does not have OMP support, yet.
  DISABLED_PACKAGES = %w(
    gpu
    kim
    user-omp
  )
  DISABLED_USER_PACKAGES = %w(
    user-atc
    user-cuda
  )

  # setup user-packages as options
  USER_PACKAGES.each do |package|
    option "enable-#{package}", "Build lammps with the '#{package}' package"
  end

  depends_on "fftw"
  depends_on "jpeg"
  depends_on "voro++"
  depends_on :mpi => [:cxx, :f90, :recommended] # dummy MPI library provided in src/STUBS
  depends_on :fortran

  def build_lib(comp, lmp_lib, opts={})
    change_compiler_var = opts[:change_compiler_var]  # a non-standard compiler name to replace
    prefix_make_var = opts[:prefix_make_var] || ""                    # prepended to makefile variable names

    cd "lib/" + lmp_lib do
      if comp == "FC"
        make_file = "Makefile.gfortran" # make file
        compiler_var = "F90"                    # replace compiler
      elsif comp == "CXX"
        make_file = "Makefile.g++"      # make file
        compiler_var = "CC"                     # replace compiler
      elsif comp == "MPICXX"
        make_file = "Makefile.openmpi"  # make file
        compiler_var = "CC"                     # replace compiler
        comp = "CXX" if not ENV["MPICXX"]
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
    IO.popen("python -c 'import sys; print sys.version[:3]'").read.strip
  end

  # This fixes the python module to point to the absolute path of the lammps library
  # without this the module cannot find the library when homebrew is installed in a
  # custom directory.
  patch :DATA

  def install
    ENV.j1      # not parallel safe (some packages have race conditions :meam:)

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
    build_lib "CXX",   "colvars", :change_compiler_var => "CXX"  if build.include? "enable-user-colvars"
    if build.include? "enable-user-awpmd"
      build_lib "MPICXX", "awpmd", :prefix_make_var => "user-"
      ENV.append "LDFLAGS", "-lblas -llapack"
    end

    # Locate gfortran library
    libgfortran = `$FC --print-file-name libgfortran.a`.chomp
    ENV.append "LDFLAGS", "-L#{File.dirname libgfortran} -lgfortran"

    # build the lammps program and library
    cd "src" do
      # setup the make file variabls for fftw, jpeg, and mpi
      inreplace "MAKE/Makefile.mac" do |s|
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
        s.change_make_var! "FFT_INC",  "-DFFT_FFTW3 -I#{Formula['fftw'].opt_prefix}/include"
        s.change_make_var! "FFT_PATH", "-L#{Formula['fftw'].opt_prefix}/lib"
        s.change_make_var! "FFT_LIB",  "-lfftw3"

        s.change_make_var! "JPG_INC",  "-DLAMMPS_JPEG -I#{Formula['jpeg'].opt_prefix}/include"
        s.change_make_var! "JPG_PATH", "-L#{Formula['jpeg'].opt_prefix}/lib"
        s.change_make_var! "JPG_LIB",  "-ljpeg"

        s.change_make_var! "CCFLAGS",  ENV["CFLAGS"]
        s.change_make_var! "LIB",      ENV["LDFLAGS"]
      end

      inreplace "VORONOI/Makefile.lammps" do |s|
        s.change_make_var! "voronoi_SYSINC", "-I#{HOMEBREW_PREFIX}/include/voro++"
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

      system "make", "mac"
      mv "lmp_mac", "lammps" # rename it to make it easier to find

      # build the lammps library
      system "make", "makeshlib"
      system "make", "-f", "Makefile.shlib", "mac"

      # install them
      bin.install("lammps")
      lib.install("liblammps_mac.so")
      lib.install("liblammps.so") # this is just a soft-link to liblamps_mac.so
    end

    # get the python module
    cd "python" do
      temp_site_packages = lib / which_python / "site-packages"
      mkdir_p temp_site_packages
      ENV["PYTHONPATH"] = temp_site_packages

      system "python", "install.py", lib, temp_site_packages
      mv "examples", "python-examples"
      prefix.install("python-examples")
    end

    # install additional materials
    (share / "lammps").install(%w(doc potentials tools bench examples))
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  test do
    ENV.prepend_create_path "PYTHONPATH", lib + "python#{pyver}/site-packages"
    # to prevent log files, move them to a temporary directory
    mktemp do
      system "lammps", "-in", "#{HOMEBREW_PREFIX}/share/lammps/bench/in.lj"
      system "python", "-c", "from lammps import lammps ; lammps().file('#{HOMEBREW_PREFIX}/share/lammps/bench/in.lj')"
    end
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

    To use the Python module with Python, you need to amend your
    PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python#{pyver}/site-packages:$PYTHONPATH

    EOS
  end
end

__END__
diff --git a/python/lammps.py b/python/lammps.py
index c65e84c..b2b28a2 100644
--- a/python/lammps.py
+++ b/python/lammps.py
@@ -23,8 +23,8 @@ class lammps:
     # if name = "g++", load liblammps_g++.so
 
     try:
-      if not name: self.lib = CDLL("liblammps.so",RTLD_GLOBAL)
-      else: self.lib = CDLL("liblammps_%s.so" % name,RTLD_GLOBAL)
+      if not name: self.lib = CDLL("HOMEBREW_PREFIX/lib/liblammps.so",RTLD_GLOBAL)
+      else: self.lib = CDLL("HOMEBREW_PREFIX/lib/liblammps_%s.so" % name,RTLD_GLOBAL)
     except:
       type,value,tb = sys.exc_info()
       traceback.print_exception(type,value,tb)
