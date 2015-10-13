class Metis4 < Formula
  desc "Serial graph partitioning and fill-reducing ordering"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz"
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  sha256 "5efa35de80703c1b2c4d0de080fafbcf4e0d363a21149a1ad2f96e0144841a55"
  revision 1

  bottle do
    cellar :any
    sha1 "e970d99900426597a3d37ad788e987d3bb8ddd52" => :yosemite
    sha1 "a97518d2f40a9cccd11705675c0c0e310246d8d4" => :mavericks
    sha1 "cab47e1fcf1376587317e1c0651e4a2f3e5a09af" => :mountain_lion
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
