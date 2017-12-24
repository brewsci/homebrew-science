class Ococo < Formula
  desc "Ococo, the first online consensus caller"
  homepage "https://github.com/karel-brinda/ococo"
  url "https://github.com/karel-brinda/ococo/archive/0.1.2.6.tar.gz"
  sha256 "f563b0ba90d47efb476b59bed144a306bc2c0c4fbc062ab3a3b87564bfdf22e6"

  head "https://github.com/karel-brinda/ococo.git"

  bottle do
    cellar :any
    sha256 "a487edf868f9f09f851d60d6d161642f683fd1ea1949ffaaf40ed0d57da01862" => :high_sierra
    sha256 "42a0faa2e0a24f6771f620cbb5fef35e7c6a9a6d07e6afe4cb682075af9dcbdd" => :sierra
    sha256 "4ca6425e31e0546a910c5a4c5261c5ca3a455371c9ee251139eb86acb8ae3b40" => :el_capitan
    sha256 "b52fabb6b7bf2944660c7ebd8db06c7e13c4298ee5891f2ed40b1dd57b4b4174" => :x86_64_linux
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
