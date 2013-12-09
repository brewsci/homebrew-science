require 'formula'

class Mumps < Formula
  homepage 'http://mumps.enseeiht.fr'
  url 'http://mumps.enseeiht.fr/MUMPS_4.10.0.tar.gz'
  mirror 'http://graal.ens-lyon.fr/MUMPS/MUMPS_4.10.0.tar.gz'
  sha1 '904b1d816272d99f1f53913cbd4789a5be1838f7'

  depends_on 'scotch5' => :optional     # Scotch 6 support currently broken.
  depends_on 'openblas' => :optional

  depends_on :mpi => [:cc, :cxx, :f90, :recommended]
  if build.with? 'mpi'
    depends_on 'scalapack' => (build.with? 'openblas') ? ['with-openblas'] : :build
  end
  depends_on 'metis4' => :optional if build.without? :mpi

  depends_on :fortran

  def install
    orderingsf = '-Dpord'
    makefile = (build.with? :mpi) ? 'Make.inc/Makefile.gfortran.PAR' : 'Make.inc/Makefile.gfortran.SEQ'

    cp makefile, 'Makefile.inc'
    inreplace 'Makefile.inc' do |s|
      if build.with? 'scotch5'
        s.gsub! /#\s*SCOTCHDIR\s*=/, 'SCOTCHDIR = '
        s.change_make_var! 'SCOTCHDIR', Formula.factory('scotch5').prefix
        s.gsub! /#\s*ISCOTCH\s*=/, 'ISCOTCH = '
        s.change_make_var! 'ISCOTCH', "-I#{Formula.factory('scotch5').include}"

        if build.with? :mpi
          s.gsub! /#\s*LSCOTCH\s*=\s*-L\$\(SCOTCHDIR\)\/lib -lptesmumps -lptscotch -lptscotcherr/, 'LSCOTCH = -L$(SCOTCHDIR)/lib -lptesmumps -lptscotch -lptscotcherr'
          orderingsf << ' -Dptscotch'
        else
          s.gsub! /#\s*LSCOTCH\s*=\s*-L\$\(SCOTCHDIR\)\/lib -lesmumps -lscotch -lscotcherr/, 'LSCOTCH = -L$(SCOTCHDIR)/lib -lesmumps -lscotch -lscotcherr'
          orderingsf << ' -Dscotch'
        end
      end

      if build.with? 'metis4'
        s.gsub! /#\s*LMETISDIR\s*=/, 'LMETISDIR = '
        s.change_make_var! 'LMETISDIR', Formula.factory('metis4').lib
        s.gsub! /#\s*IMETIS\s*=/, 'IMETIS = '
        s.change_make_var! 'IMETIS', Formula.factory('metis4').include
        s.sub! /#\s*LMETIS\s*=/, 'LMETIS = '
        s.change_make_var! 'LMETIS', "-L#{Formula.factory('metis4').lib} -lmetis"
        orderingsf << ' -Dmetis'
      end

      s.change_make_var! 'ORDERINGSF', orderingsf

      # Build a shared library.
      s.change_make_var! 'LIBEXT', '.dylib'
      s.change_make_var! 'CC', "#{ENV.cc} -fPIC"
      s.change_make_var! 'FC', "#{ENV.fc} -fPIC"
      s.change_make_var! 'FL', "#{ENV.fc} -fPIC"
      s.change_make_var! 'AR', "$(FL) -shared -Wl,-install_name -Wl,#{lib}/$(notdir $@) -undefined dynamic_lookup -o "  # Must have a trailing whitespace!
      s.change_make_var! 'RANLIB', 'echo'

      if build.with? :mpi
        s.change_make_var! 'SCALAP', "-L#{Formula.factory('scalapack').lib} -lscalapack"
        s.change_make_var! 'INCPAR', "-I#{Formula.factory('open-mpi').include}"
        s.change_make_var! 'LIBPAR', "$(SCALAP) -L#{Formula.factory('open-mpi').lib} -lmpi -lmpi_mpifh"
      end

      if build.with? 'openblas'
        s.change_make_var! 'LIBBLAS', "-L#{Formula.factory('openblas').lib} -lopenblas"
      else
        s.change_make_var! 'LIBBLAS', '-lblas -llapack'
      end
    end

    ENV.deparallelize  # Build fails in parallel on Mavericks.
    system 'make all'

    prefix.install 'Makefile.inc'  # For the record.
    lib.install Dir['lib/*']

    if build.with? :mpi
      include.install Dir['include/*']
    else
      lib.install 'libseq/libmpiseq.dylib'
      libexec.install 'include'
      include.install_symlink Dir[libexec/'include/*']
      # The following .h files may conflict with others related to MPI
      # in /usr/local/include. Do not symlink them.
      (libexec/'include').install Dir['libseq/*.h']
    end

    (share+'doc').install Dir['doc/*.pdf']
    (share+'examples').install Dir['examples/*[^.o]']
  end

  def caveats
    s = ''
    if build.without? :mpi
      s += <<-EOS.undent
      You built a sequential MUMPS library.
      Please add #{libexec}/include to the include path
      when building software that depends on MUMPS.
      EOS
    end
    return s
  end

  def test
    cmd = (Tab.for_formula(self).used_options.include? 'without-mpi') ? '' : 'mpirun -np 2'
    system "#{cmd} #{share}/examples/ssimpletest < #{share}/examples/input_simpletest_real"
    system "#{cmd} #{share}/examples/dsimpletest < #{share}/examples/input_simpletest_real"
    system "#{cmd} #{share}/examples/csimpletest < #{share}/examples/input_simpletest_cmplx"
    system "#{cmd} #{share}/examples/zsimpletest < #{share}/examples/input_simpletest_cmplx"
    system "#{cmd} #{share}/examples/c_example"
    ohai "Test results are in ~/Library/Logs/Homebrew/mumps"
  end
end
