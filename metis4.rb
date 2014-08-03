require 'formula'

class Metis4 < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  sha1 '63303786414a857eaeea2b2a006521401bccda5e'

  keg_only "Conflicts with metis (5.x)."

  def install
    inreplace "Lib/Makefile", "libmetis.a", "libmetis.dylib"
    make_args = ["COPTIONS=-fPIC",
                 "AR=libtool -dynamic -install_name #{lib}/$(notdir $@) -undefined dynamic_lookup -o",
                 "RANLIB=echo",
                 "METISLIB=../libmetis.dylib"]
    system "make", *make_args
    bin.install %w(pmetis kmetis oemetis onmetis partnmesh partdmesh mesh2nodal mesh2dual graphchk)
    lib.install "libmetis.dylib"
    include.install Dir["Lib/*.h"]
    (share / "metis4").install %w(Graphs/mtest Graphs/4elt.graph Graphs/metis.mesh Graphs/test.mgraph)
  end

  test do
    system "#{share}/metis4/mtest", "#{share}/metis4/4elt.graph"
    system "#{bin}/kmetis", "#{share}/metis4/4elt.graph", "40"
    system "#{bin}/onmetis", "#{share}/metis4/4elt.graph"
    system "#{bin}/pmetis", "#{share}/metis4/test.mgraph", "2"
    system "#{bin}/kmetis", "#{share}/metis4/test.mgraph", "2"
    system "#{bin}/kmetis", "#{share}/metis4/test.mgraph", "5"
    system "#{bin}/partnmesh", "#{share}/metis4/metis.mesh", "10"
    system "#{bin}/partdmesh", "#{share}/metis4/metis.mesh", "10"
    system "#{bin}/mesh2dual", "#{share}/metis4/metis.mesh"
  end
end
