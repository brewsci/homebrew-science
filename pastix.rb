require 'formula'

class Pastix < Formula
  homepage 'http://pastix.gforge.inria.fr'
  url 'https://gforge.inria.fr/frs/download.php/32932/pastix_release_4492.tar.bz2'
  sha1 '87acd507048e416e1758c9ef9461c59b4e7223a5'
  head 'svn://scm.gforge.inria.fr/svnroot/ricar/tags/5.2.1'
  version '5.2.1'

  depends_on 'scotch'   => :build
  depends_on 'metis4'   => :optional     # Use METIS ordering.
  depends_on 'openblas' => :optional     # Use Accelerate by default.
  depends_on 'open-mpi' => 'enable-mpi-thread-multiple'

  depends_on :mpi       => [:cc, :f90]
  depends_on :fortran

  def install
    cd 'src' do
      cp 'config/MAC.in', 'config.in'
      inreplace 'config.in' do |s|
        s.change_make_var! "CCPROG", ENV.compiler
        s.change_make_var! "CFPROG", ENV['FC']
        s.change_make_var! "CF90PROG", ENV['FC']

        libgfortran = `mpif90 --print-file-name libgfortran.a`.chomp
        s.change_make_var! "EXTRALIB", "-L#{File.dirname(libgfortran)} -lgfortran -lm"

        s.gsub! /#\s*ROOT\s*=/, "ROOT = "
        s.change_make_var! "ROOT", prefix
        s.gsub! /#\s*INCLUDEDIR\s*=/, "INCLUDEDIR = "
        s.change_make_var! "INCLUDEDIR", include
        s.gsub! /#\s*LIBDIR\s*=/, "LIBDIR = "
        s.change_make_var! "LIBDIR", lib
        s.gsub! /#\s*BINDIR\s*=/, "BINDIR = "
        s.change_make_var! "BINDIR", bin

        s.gsub! /#\s*SHARED\s*=/, "SHARED = "
        s.change_make_var! "SHARED", 1
        s.gsub! /#\s*SOEXT\s*=/, "SOEXT = "
        s.gsub! /#\s*SHARED_FLAGS\s*=/, "SHARED_FLAGS = "

        s.gsub! /#\s*CCFDEB\s*:=/, "CCFDEB := "
        s.gsub! /#\s*CCFOPT\s*:=/, "CCFOPT := "
        s.gsub! /#\s*CFPROG\s*:=/, "CFPROG := "

        s.gsub! /#\s*VERSIONINT\s+=\s+_int32/, "VERSIONINT = _int32"
        s.gsub! /#\s*CCTYPES\s+=\s+\-DINTSIZE32/, "CCTYPES = -DINTSIZE32"

        s.gsub! /SCOTCH_HOME\s*\?=/, "SCOTCH_HOME="
        s.change_make_var! "SCOTCH_HOME", Formula.factory('scotch').prefix

        if build.with? 'metis4'
          s.gsub! /#\s*VERSIONORD\s*=\s*_metis/, "VERSIONORD = _metis"
          s.gsub! /#\s*METIS_HOME/, "METIS_HOME"
          s.change_make_var! "METIS_HOME", Formula.factory('metis4').prefix
          s.gsub! /#\s*CCPASTIX\s*:=\s*\$\(CCPASTIX\)\s+-DMETIS\s+-I\$\(METIS_HOME\)\/Lib/, "CCPASTIX := \$(CCPASTIX) -DMETIS -I#{Formula.factory('metis4').include}"
          s.gsub! /#\s*EXTRALIB\s*:=\s*\$\(EXTRALIB\)\s+-L\$\(METIS_HOME\)\s+-lmetis/, "EXTRALIB := \$\(EXTRALIB\) -L#{Formula.factory('metis4').lib} -lmetis"
        end

        if build.with? 'openblas'
          s.gsub! /#\s*BLAS_HOME\s*=\s*\/path\/to\/blas/, "BLAS_HOME = #{Formula.factory('openblas').lib}"
          s.change_make_var! "BLASLIB", "-lopenblas"
        end
      end
      system "make"
      system "make install"
      system "make examples"
      system "./example/bin/simple -lap 100"
      prefix.install 'config.in'    # For the record.
      share.install 'example'       # Contains all test programs.
      ohai 'Simple test result is in ~/Library/Logs/Homebrew/pastix. Please check.'
    end
  end

  def test
    Dir.foreach("#{share}/example/bin") do |example|
      next if example =~ /^\./ or example =~ /plot_memory_usage/
      next if example == 'reentrant'  # May fail due to thread handling. See http://goo.gl/SKDGPV
      if example == 'murge-product'
        system "#{share}/example/bin/#{example} 100 10 1"
      elsif example =~ /murge/
        system "#{share}/example/bin/#{example} 100 100"
      else
        system "#{share}/example/bin/#{example} -lap 100"
      end
    end
    ohai 'All test output is in ~/Library/Logs/Homebrew/pastix. Please check.'
  end
end
