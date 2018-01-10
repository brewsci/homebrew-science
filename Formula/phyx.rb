class Phyx < Formula
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v0.99.tar.gz"
  sha256 "6c767b2b2a9666849c3035e479a2135734fccf882d4957f69ea251632d7ed010"
  revision 1
  head "https://github.com/FePhyFoFum/phyx.git"

  bottle do
    cellar :any
    sha256 "fcd1b54a0e6a48e66b0ed159027f5066238dc5095144f812c7aec3caed210155" => :sierra
    sha256 "f40c1d91df0c64c08644d7ebe05b667729763442ed6bc3d3f12eb40db123ba76" => :el_capitan
    sha256 "383caf7c3a87f84ec17f4d2525a2e838f04616ed80d04d428a71738ea9adb403" => :yosemite
    sha256 "43a2917b0e5bc8bc440008386c676a69bd90225c0c03c9954a64fff66ece53e3" => :x86_64_linux
  end

  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btx063"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :fortran
  depends_on "armadillo"
  depends_on "nlopt"

  def install
    cd "src" do
      system "autoreconf", "-fvi"
      # configure doesn't respect LDFLAGS. Fixed in HEAD version > 0.9
      fortran = File.dirname `#{ENV.fc} --print-file-name libgfortran.a`
      inreplace "Makefile.in", "@OPT_FLAGS@", "@OPT_FLAGS@ -L#{fortran}"
      # configure doesn't properly detect nlopt on Linux.
      inreplace "Makefile.in", "@HNLOPT@", "Y" if OS.linux?
      system "./configure", "--prefix=#{prefix}"
      system "make"
      bin.install Dir["px*"] # Makefile installs directly to prefix
    end
    pkgshare.install Dir["example_files/*"]
  end

  test do
    system "#{bin}/pxseqgen", "-t", "#{pkgshare}/pxseqgen_example/seqgen_test.tre", "-o", "output.fa"
    File.exist? "output.fa"
  end
end
