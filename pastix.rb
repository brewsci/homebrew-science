class Pastix < Formula
  homepage "http://pastix.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/34392/pastix_5.2.2.20.tar.bz2"
  sha1 "d55acf287ed0b6a59fc12606a21e42e3d38507c5"
  head "git://scm.gforge.inria.fr/ricar/ricar.git"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 1
    sha1 "3a68c6e5d78b8ab750370e92f29ffb8f51abd14d" => :yosemite
    sha1 "0c280a7b759067ecac5e3f32a151f1bfca17e15e" => :mavericks
    sha1 "1192570bc5cb3339f69d962743bb597323e6a3bf" => :mountain_lion
  end

  depends_on "scotch"   => :build
  depends_on "hwloc"
  depends_on "metis4"   => :optional     # Use METIS ordering.
  depends_on "openblas" => :optional     # Use Accelerate by default.

  depends_on :mpi       => [:cc, :cxx, :f90]
  depends_on :fortran

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
        s.change_make_var! "VERSIONBIT", ((MacOS.prefer_64_bit?) ? "_64bit" : "_32bit")

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
      system "make", "examples"
      system "./example/bin/simple", "-lap", "100"
      prefix.install "config.in"    # For the record.
      share.install "example"       # Contains all test programs.
      ohai "Simple test result is in ~/Library/Logs/Homebrew/pastix. Please check."
    end
  end

  test do
    Dir.foreach("#{share}/example/bin") do |example|
      next if example =~ /^\./ || example =~ /plot_memory_usage/ || example =~ /mem_trace.o/ || example =~ /murge_sequence/
      next if example == "reentrant"  # May fail due to thread handling. See http://goo.gl/SKDGPV
      if example == "murge-product"
        system "#{share}/example/bin/#{example}", "100", "10", "1"
      elsif example =~ /murge/
        system "#{share}/example/bin/#{example}", "100", "4"
      else
        system "#{share}/example/bin/#{example}", "-lap", "100"
      end
    end
    ohai "All test output is in ~/Library/Logs/Homebrew/pastix. Please check."
  end
end
