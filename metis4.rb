require 'formula'

class Metis4 < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  sha1 '63303786414a857eaeea2b2a006521401bccda5e'

  keg_only "Conflicts with metis (5.x)."

  def install
    system "make"
    bin.install %w(pmetis kmetis oemetis onmetis partnmesh partdmesh mesh2nodal mesh2dual graphchk Graphs/mtest)
    lib.install 'libmetis.a'
    include.install Dir['Lib/*.h']
  end
end
