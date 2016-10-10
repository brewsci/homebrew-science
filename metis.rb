class Metis < Formula
  desc "Serial programs that partition graphs and order matrices"
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz"
  sha256 "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2"

  bottle do
    cellar :any
    revision 1
    sha256 "cd1d538230d1c589d1e42d1d6a8f4c36e540572743a1aead69463ce544b3dd69" => :el_capitan
    sha256 "6cf085111dd13789dafa876363d0a9b290ea33ee0db5fea6c4f69fbb4e8a9b2a" => :yosemite
    sha256 "4dd9efbec7accf007b469e613a7a47fe32ae4328cd7bd326ceba91c255f80db9" => :mavericks
    sha256 "28d257e79e25936ffbbacc7e3e8756952ec3061c41bfca86414c4cb3f9f5eeae" => :x86_64_linux
  end

  option :universal
  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "cmake" => :build

  needs :openmp if build.with? "openmp"

  def install
    ENV.universal_binary if build.universal?

    # Make clang 7.3 happy. Check if still needed when Xcode > 7.3 is released.
    # Prevents "ld: section __DATA/__thread_bss extends beyond end of file"
    # See upstream LLVM issue https://llvm.org/bugs/show_bug.cgi?id=27059
    # Issue and patch reported to karypis@cs.umn.edu (31st Mar 2016)
    inreplace "GKlib/error.c", "#define MAX_JBUFS 128", "#define MAX_JBUFS 24"

    make_args = ["shared=1", "prefix=#{prefix}"]
    make_args << "openmp=" + ((build.with? "openmp") ? "0" : "1")
    system "make", "config", *make_args
    system "make", "install"

    pkgshare.install "graphs"
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
