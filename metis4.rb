class Metis4 < Formula
  desc "Serial graph partitioning and fill-reducing ordering"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz"
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  sha256 "5efa35de80703c1b2c4d0de080fafbcf4e0d363a21149a1ad2f96e0144841a55"
  revision 1

  bottle do
    cellar :any
    sha256 "93bcbf85b09f04605bb89bd8b21654aeb74ead15d9850f100316310e76b012fc" => :el_capitan
    sha256 "e3e0b810f44b481cd75fa2125c6a8d4cfab598297a779cf1d1aa892bd327fa69" => :yosemite
    sha256 "b0631095992610abe58e927797cbb852899b6a8c4471bd5fea291a628b034edd" => :mavericks
  end

  keg_only "Conflicts with metis (5.x)."

  def install
    if OS.mac?
      so = "dylib"
      all_load = "-Wl,-all_load"
      noall_load = ""
    else
      so = "so"
      all_load = "-Wl,-whole-archive"
      noall_load = "-Wl,-no-whole-archive"
    end
    cd "Lib" do
      system "make", "CC=#{ENV.cc}", "COPTIONS=-fPIC"
    end
    cd "Programs" do
      system "make", "CC=#{ENV.cc}", "COPTIONS=-fPIC"
    end
    system ENV.cc, "-fPIC", "-shared", "#{all_load}", "libmetis.a", "#{noall_load}", "-o", "libmetis.#{so}"
    bin.install %w[pmetis kmetis oemetis onmetis partnmesh partdmesh mesh2nodal mesh2dual graphchk]
    lib.install "libmetis.#{so}"
    include.install Dir["Lib/*.h"]
    pkgshare.install %w[Programs/io.c Test/mtest.c Graphs/4elt.graph Graphs/metis.mesh Graphs/test.mgraph]
  end

  test do
    cp pkgshare/"io.c", testpath
    cp pkgshare/"mtest.c", testpath
    system ENV.cc, "-I#{include}", "-c", "io.c"
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmetis", "mtest.c", "io.o", "-o", "mtest"
    system "./mtest", "#{pkgshare}/4elt.graph"
    system "#{bin}/kmetis", "#{pkgshare}/4elt.graph", "40"
    system "#{bin}/onmetis", "#{pkgshare}/4elt.graph"
    system "#{bin}/pmetis", "#{pkgshare}/test.mgraph", "2"
    system "#{bin}/kmetis", "#{pkgshare}/test.mgraph", "2"
    system "#{bin}/kmetis", "#{pkgshare}/test.mgraph", "5"
    system "#{bin}/partnmesh", "#{pkgshare}/metis.mesh", "10"
    system "#{bin}/partdmesh", "#{pkgshare}/metis.mesh", "10"
    system "#{bin}/mesh2dual", "#{pkgshare}/metis.mesh"
  end
end
