require 'formula'

class Lammps < Formula
  homepage 'http://lammps.sandia.gov'
  url 'http://lammps.sandia.gov/tars/lammps-12Jan13.tar.gz'
  sha1 'da31b931dc38d00fef2e5d61b924154c5d538240'
  # lammps releases are named after their release date. We transform it to
  # YYYY.MM.RR (year.month.revision) so that we get a comparable version numbering (for brew outdated)
  version '2013.01.12'
  head 'http://git.icms.temple.edu/lammps-ro.git'

  # user-submitted packages not considered "standard"
  USER_PACKAGES= %W[
    user-misc
    user-awpmd
    user-cg-cmm
    user-colvars
    user-eff
    user-omp
    user-molfile
    user-reaxc
    user-sph
  ]

  # could not get gpu or user-cuda to install (hardware problem?)
  # kim requires openkim software, which is not currently in homebrew.
  # user-atc would not install without mpi and then would not link to blas-lapack
  DISABLED_PACKAGES = %W[
    gpu
    kim
  ]
  DISABLED_USER_PACKAGES = %W[
    user-atc
    user-cuda
  ]

  # setup user-packages as options
  USER_PACKAGES.each do |package|
    option "enable-#{package}", "Build lammps with the '#{package}' package"
  end

  # additional options
  option "with-mpi", "Build lammps with MPI support"

  depends_on 'fftw'
  depends_on 'jpeg'
  depends_on MPIDependency.new(:cxx, :f90) if build.include? "with-mpi"

  def build_f90_lib(lmp_lib)
    # we currently assume gfortran is our fortran library
    cd "lib/"+lmp_lib do
      make_file = "Makefile.gfortran"
      if build.include? "with-mpi"
        inreplace make_file do |s|
          s.change_make_var! "F90", ENV["MPIFC"]
        end
      end
      system "make", "-f", make_file

      ENV.append 'LDFLAGS', "-lgfortran -L#{Formula.factory('gfortran').opt_prefix}/gfortran/lib"

      # empty it to reduce chance of conflicts
      inreplace "Makefile.lammps" do |s|
        s.change_make_var! lmp_lib+"_SYSINC", ""
        s.change_make_var! lmp_lib+"_SYSLIB", "-lgfortran"
        s.change_make_var! lmp_lib+"_SYSPATH", ""
      end
    end
  end

  def build_cxx_lib(lmp_lib)
    cd "lib/"+lmp_lib do
      make_file = "Makefile.g++"
      if build.include? "with-mpi"
        make_file = "Makefile.openmpi" if File.exists? "Makefile.openmpi"
        inreplace make_file do |s|
          s.change_make_var! "CC" , ENV["MPICXX"]
        end
      end
      system "make", "-f", make_file
    end
  end

  def install
    ENV.j1      # not parallel safe (some packages have race conditions :meam:)
    ENV.fortran # we need fortran for many packages, so just bring it along

    build_f90_lib "reax"
    build_f90_lib "meam"
    build_cxx_lib "poems"
    build_cxx_lib "awpmd" if build.include? "enable-user-awpmd" and build.include? "with-mpi"
    if build.include? "enable-user-colvars"
      # the makefile is craeted by a user and is not of standard format
      cd "lib/colvars" do
        make_file = "Makefile.g++"
        if build.include? "with-mpi"
          inreplace make_file do |s|
            s.change_make_var! "CXX" , ENV["MPICXX"]
          end
        end
        system "make", "-f", make_file
      end
    end

    # build the lammps program and library
    cd "src" do
      # setup the make file variabls for fftw, jpeg, and mpi
      inreplace "MAKE/Makefile.mac" do |s|
        # We will stick with "make mac" type and forget about
        # "make mac_mpi" because it has some unnecessary
        # settings. We get a nice clean slate with "mac"
        if build.include? "with-mpi"
          # compiler info
          s.change_make_var! "CC"     , ENV["MPICXX"]
          s.change_make_var! "LINK"   , ENV["MPICXX"]

          #-DOMPI_SKIP_MPICXX is to speed up c++ compilation
          s.change_make_var! "MPI_INC"  , "-DOMPI_SKIP_MPICXX -I#{HOMEBREW_PREFIX}/include"
          s.change_make_var! "MPI_PATH" , "-L#{HOMEBREW_PREFIX}/lib"
          s.change_make_var! "MPI_LIB"  , ""
        end

        # installing with FFTW and JPEG
        s.change_make_var! "FFT_INC"  , "-DFFT_FFTW3 -I#{Formula.factory('fftw').opt_prefix}/include"
        s.change_make_var! "FFT_PATH" , "-L#{Formula.factory('fftw').opt_prefix}/lib"
        s.change_make_var! "FFT_LIB"  , "-lfftw3"

        s.change_make_var! "JPG_INC"  , "-DLAMMPS_JPEG -I#{Formula.factory('jpeg').opt_prefix}/include"
        s.change_make_var! "JPG_PATH" , "-L#{Formula.factory('jpeg').opt_prefix}/lib"
        s.change_make_var! "JPG_LIB"  , "-ljpeg"

        # add link-flags
        s.change_make_var! "LINKFLAGS"  , ENV["LDFLAGS"]
        s.change_make_var! "SHLIBFLAGS" , "-shared #{ENV['LDFLAGS']}"
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

      unless build.include? "with-mpi"
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
      temp_site_packages = lib/which_python/'site-packages'
      mkdir_p temp_site_packages
      ENV['PYTHONPATH'] = temp_site_packages

      system "python", "install.py", lib, temp_site_packages
      mv "examples", "python-examples"
      prefix.install("python-examples")
    end

    # install additional materials
    (share/'lammps').install(["doc", "potentials", "tools", "bench"])
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def test
    # to prevent log files, move them to a temporary directory
    mktemp do
      system "lammps","-in","#{HOMEBREW_PREFIX}/share/lammps/bench/in.lj"
      system "python","-c","from lammps import lammps ; lammps().file('#{HOMEBREW_PREFIX}/share/lammps/bench/in.lj')"
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

    To use the Python module with non-homebrew Python, you need to amend your
    PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python2.7/site-packages:$PYTHONPATH

    EOS
  end

  # This fixes the python module to point to the absolute path of the lammps library
  # without this the module cannot find the library when homebrew is installed in a
  # custom directory.
  def patches
    DATA
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
