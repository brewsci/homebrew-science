require 'formula'

class Scotch < Formula
  homepage 'https://gforge.inria.fr/projects/scotch'
  url 'https://gforge.inria.fr/frs/download.php/31831/scotch_6.0.0.tar.gz'
  sha1 'eb32d846bb14449245b08c81e740231f7883fea6'

  depends_on :mpi => :cc

  def install
    cd 'src' do
      ln_s 'Make.inc/Makefile.inc.i686_mac_darwin8', 'Makefile.inc'

      make_args = ["CCS=#{ENV['CC']}", "CCP=#{ENV['MPICC']}", "CCD=#{ENV['MPICC']}"]
      inreplace 'Makefile.inc' do |s|
        # OS X doesn't implement pthread_barriers required by Scotch
        s.slice! '-DCOMMON_PTHREAD'
        s.slice! '-DSCOTCH_PTHREAD'
      end
      system 'make', 'scotch', 'VERBOSE=ON', *make_args
      system 'make', 'ptscotch', 'VERBOSE=ON', *make_args
      system 'make', 'install', "prefix=#{prefix}", *make_args
    end
  end
end
