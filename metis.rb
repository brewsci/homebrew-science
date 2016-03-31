class Metis < Formula
  desc "Serial programs that partition graphs and order matrices"
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz"
  sha256 "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2"

  bottle do
    cellar :any
    sha256 "1e127767a51ae71e36fee29e3f646dc038898c1cca7da5b707266456ff50f5ac" => :yosemite
    sha256 "da4e731c9c8c1b295e300eafe1851171cb08793484b0583ca6606a8344dae9ee" => :mavericks
    sha256 "5ab878427e696a9893aeb9c69b18938430adfd8d1cdfd37b0c7149aa5aa68e19" => :mountain_lion
  end

  option :universal

  depends_on "cmake" => :build

  def install
    ENV.universal_binary if build.universal?

    # Make clang 7.3 happy. Check if still needed when Xcode > 7.3 is released.
    # Prevents "ld: section __DATA/__thread_bss extends beyond end of file"
    # See upstream LLVM issue https://llvm.org/bugs/show_bug.cgi?id=27059
    # Issue and patch reported to karypis@cs.umn.edu (31st Mar 2016)
    inreplace "GKlib/error.c", "#define MAX_JBUFS 128", "#define MAX_JBUFS 24"

    make_args = ["shared=1", "prefix=#{prefix}"]
    make_args << "openmp=" + ((ENV.compiler == :clang) ? "0" : "1")
    system "make", "config", *make_args
    system "make", "install"

    (share / "metis").install "graphs"
    doc.install "manual"
  end

  test do
    ["4elt", "copter2", "mdual"].each do |g|
      cp pkgshare/"graphs/#{g}.graph", testpath
      system "#{bin}/graphchk", "#{g}.graph"
      system "#{bin}/gpmetis", "#{g}.graph", "2"
      system "#{bin}/ndmetis", "#{g}.graph"
    end
    cp [pkgshare/"graphs/test.mgraph", pkgshare/"graphs/metis.mesh"], testpath
    system "#{bin}/gpmetis", "test.mgraph", "2"
    system "#{bin}/mpmetis", "metis.mesh", "2"
  end
end
