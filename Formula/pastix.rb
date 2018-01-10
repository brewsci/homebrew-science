class Pastix < Formula
  desc "Parallel solver for sparse linear systems based on direct methods"
  homepage "http://pastix.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/35070/pastix_5.2.2.22.tar.bz2"
  sha256 "30f771a666719e6b116f549a6e4da451beabab99c2ecabc0745247c3654acbed"
  revision 4

  head "https://scm.gforge.inria.fr/anonscm/git/ricar/ricar.git"

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  depends_on "scotch"
  depends_on "hwloc"
  depends_on "metis4"   => :optional     # Use METIS ordering.
  depends_on "openblas" => :optional     # Use Accelerate by default.

  depends_on :mpi       => [:cc, :cxx, :f90]
  depends_on :fortran
  depends_on "gcc"

  def install
    ENV.deparallelize

    cd "src" do
      cp "config/MAC.in", "config.in"
      inreplace "config.in" do |s|
        s.change_make_var! "CCPROG",    ENV.compiler
        s.change_make_var! "CFPROG",    ENV["FC"]
        s.change_make_var! "CF90PROG",  ENV["FC"]
        s.change_make_var! "MCFPROG",   ENV["MPIFC"]
        s.change_make_var! "MPCCPROG",  ENV["MPICC"]
        s.change_make_var! "MPCXXPROG", ENV["MPICXX"]
        s.change_make_var! "VERSIONBIT", MacOS.prefer_64_bit? ? "_64bit" : "_32bit"

        libgfortran = `#{ENV["MPIFC"]} --print-file-name libgfortran.a`.chomp
        s.change_make_var! "EXTRALIB", "-L#{File.dirname(libgfortran)} -lgfortran -lm"

        # set prefix
        s.gsub! /#\s*ROOT\s*=/, "ROOT = "
        s.change_make_var! "ROOT", prefix
        s.gsub! /#\s*INCLUDEDIR\s*=/, "INCLUDEDIR = "
        s.change_make_var! "INCLUDEDIR", include
        s.gsub! /#\s*LIBDIR\s*=/, "LIBDIR = "
        s.change_make_var! "LIBDIR", lib
        s.gsub! /#\s*BINDIR\s*=/, "BINDIR = "
        s.change_make_var! "BINDIR", bin
        s.gsub! /#\s*PYTHON_PREFIX\s*=/, " PYTHON_PREFIX = "

        # shared library building
        s.gsub! /#\s*SHARED\s*=/, "SHARED = "
        s.change_make_var! "SHARED", 1
        s.gsub! /#\s*SOEXT\s*=/, "SOEXT = "
        s.gsub! /#\s*SHARED_FLAGS\s*=/, "SHARED_FLAGS = "

        # activate FUNNELED mode
        s.gsub! /#\s*CCPASTIX\s*:=\s*\$\(CCPASTIX\)\s+-DPASTIX_FUNNELED/, "CCPASTIX := \$(CCPASTIX) -DPASTIX_FUNNELED"

        s.gsub! /#\s*CCFDEB\s*:=/, "CCFDEB := "
        s.gsub! /#\s*CCFOPT\s*:=/, "CCFOPT := "
        s.gsub! /#\s*CFPROG\s*:=/, "CFPROG := "

        s.gsub! /SCOTCH_HOME\s*\?=/, "SCOTCH_HOME="
        s.change_make_var! "SCOTCH_HOME", Formula["scotch"].opt_prefix

        s.gsub! /HWLOC_HOME\s*\?=/, "HWLOC_HOME="
        s.change_make_var! "HWLOC_HOME", Formula["hwloc"].opt_prefix

        if build.with? "metis4"
          s.gsub! /#\s*VERSIONORD\s*=\s*_metis/, "VERSIONORD = _metis"
          s.gsub! /#\s*METIS_HOME/, "METIS_HOME"
          s.change_make_var! "METIS_HOME", Formula["metis4"].opt_prefix
          s.gsub! %r{#\s*CCPASTIX\s*:=\s*\$\(CCPASTIX\)\s+-DMETIS\s+-I\$\(METIS_HOME\)/Lib}, "CCPASTIX := \$(CCPASTIX) -DMETIS -I#{Formula["metis4"].opt_include}"
          s.gsub! /#\s*EXTRALIB\s*:=\s*\$\(EXTRALIB\)\s+-L\$\(METIS_HOME\)\s+-lmetis/, "EXTRALIB := \$\(EXTRALIB\) -L#{Formula["metis4"].opt_lib} -lmetis"
        end

        if build.with? "openblas"
          s.gsub! %r{#\s*BLAS_HOME\s*=\s*/path/to/blas}, "BLAS_HOME = #{Formula["openblas"].opt_lib}"
          s.change_make_var! "BLASLIB", "-lopenblas"
        end
      end
      system "make"
      system "make", "install"

      # Build examples against just installed libraries, so they continue to
      # work once the temporary directory is gone, e.g., for `brew test`.
      system "make", "examples", "PASTIX_BIN=#{bin}",
                                 "PASTIX_LIB=#{lib}",
                                 "PASTIX_INC=#{include}"
      system "./example/bin/simple", "-lap", "100"
      prefix.install "config.in" # For the record.
      pkgshare.install "example" # Contains all test programs.
      ohai "Simple test result is in #{HOMEBREW_LOGS}/pastix. Please check."
    end
  end

  test do
    Dir.foreach("#{pkgshare}/example/bin") do |example|
      next if example =~ /^\./ || example =~ /plot_memory_usage/ || example =~ /mem_trace.o/ || example =~ /murge_sequence/
      next if example == "reentrant" # May fail due to thread handling. See https://goo.gl/SKDGPV
      if example == "murge-product"
        system "#{pkgshare}/example/bin/#{example}", "100", "10", "1"
      elsif example =~ /murge/
        system "#{pkgshare}/example/bin/#{example}", "100", "4"
      else
        system "#{pkgshare}/example/bin/#{example}", "-lap", "100"
      end
    end
    ohai "All test output is in #{HOMEBREW_LOGS}/pastix. Please check."
  end
end
