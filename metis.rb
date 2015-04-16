class Metis < Formula
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz"
  sha256 "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2"

  option :universal

  depends_on "cmake" => :build

  def install
    ENV.universal_binary if build.universal?
    make_args = ["shared=1", "prefix=#{prefix}"]
    make_args << "openmp=" + ((ENV.compiler == :clang) ? "0" : "1")
    system "make", "config", *make_args
    system "make", "install"

    (share / "metis").install "graphs"
    doc.install "manual"
  end

  test do
    ["4elt", "copter2", "mdual"].each do |g|
      system "#{bin}/graphchk", "#{share}/metis/graphs/#{g}.graph"
      system "#{bin}/gpmetis", "#{share}/metis/graphs/#{g}.graph", "2"
      system "#{bin}/ndmetis", "#{share}/metis/graphs/#{g}.graph"
    end
    system "#{bin}/gpmetis", "#{share}/metis/graphs/test.mgraph", "2"
    system "#{bin}/mpmetis", "#{share}/metis/graphs/metis.mesh", "2"
  end
end
