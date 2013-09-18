require 'formula'

class Parmetis < Formula
  homepage 'http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview'
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz'
  sha1 'e0df69b037dd43569d4e40076401498ee5aba264'

  # METIS 5.* is required. It comes bundled with ParMETIS but is not
  # installed by default. We prefer to brew it ourselves.
  depends_on 'metis' => :build

  depends_on 'cmake' => :build
  depends_on :mpi => :cc

  def install
    system "make", "config", "prefix=#{prefix}"
    system 'make install'
    share.install 'Graphs' # Sample data for test
  end

  def test
    system "mpirun -np 4 #{bin}/ptest #{share}/Graphs/rotor.graph"
    ohai "Test results are in ~/Library/Logs/Homebrew/parmetis."
  end
end
