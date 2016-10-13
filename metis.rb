class Metis < Formula
  desc "Serial programs that partition graphs and order matrices"
  homepage "http://glaros.dtc.umn.edu/gkhome/views/metis"
  url "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz"
  sha256 "76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2"

  bottle do
    cellar :any
    rebuild 2
    sha256 "2823ed824da175fb8f09a26b59cafa57cc2f52c5052bff57ed454888a4d1ba86" => :sierra
    sha256 "40ab306bef9447b8d35eff4b7193a3795c627b40f1baf5a9372a3eb4509c60d4" => :el_capitan
    sha256 "e38752a78e5a6d873dddb4b4c9f87d77bd9cec6c4b9efc8f9fd7367aecc0cfbb" => :yosemite
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
