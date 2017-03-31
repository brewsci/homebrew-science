class Ococo < Formula
  desc "Ococo, the first online consensus caller"
  homepage "https://github.com/karel-brinda/ococo"
  url "https://github.com/karel-brinda/ococo/archive/0.1.2.4.tar.gz"
  sha256 "1716b012acd7e08949ccfbc491d8b018c69b10128bff558f43624a176c871109"

  head "https://github.com/karel-brinda/ococo.git"

  bottle do
    cellar :any
    sha256 "b9145919260ca03c415fc0da4902427f9eed390e16856a21aec8615df44232d7" => :sierra
    sha256 "4eabdc5d8bbc2701a955221621ab39a369ddfea15d3e610cc0be832f1b81ce32" => :el_capitan
    sha256 "5faaaa13bfb44ab4f2bbf45592158939fb54c5589488817e43c5815f114e7a20" => :yosemite
    sha256 "494d48f491c3bf454748e1501d8d4f199b06abd39c581eaa1613f45f9e6a1df5" => :x86_64_linux
  end

  depends_on "htslib"
  depends_on "xz"

  def install
    dylib = OS.mac? ? "dylib" : "so"
    system "make", "HTSLIBINCLUDE=#{Formula["htslib"].opt_include}", "HTSLIB=#{Formula["htslib"].opt_lib}/libhts.#{dylib}"
    bin.install "ococo"
    man1.install "ococo.1"
  end

  test do
    system "#{bin}/ococo", "-v"
    (testpath/"test.sam").write "@SQ\tSN:chrom1\tLN:42424242\nread\t0\tchrom1\t2798553\t60\t5M\t*\t0\t0\tAAAGG\t*"
    assert_match "5", shell_output("#{bin}/ococo -i test.sam -P - 2>/dev/null | wc -l")
  end
end
