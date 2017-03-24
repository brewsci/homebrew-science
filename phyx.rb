class Phyx < Formula
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v0.99.tar.gz"
  sha256 "6c767b2b2a9666849c3035e479a2135734fccf882d4957f69ea251632d7ed010"
  head "https://github.com/FePhyFoFum/phyx.git"
  bottle do
    cellar :any
    sha256 "a77ee41a84d4e80be7df6b59f48d8b43c76c90402b419cdae5968647e5c6b9de" => :sierra
    sha256 "d0c143dcb36c75d2204c2b6911f9098bf766f3fbcd85bdc102d0d482cf7ff66f" => :el_capitan
    sha256 "00d93d800fdb860a0c86d204b54a69243d6398c9877d96a66a821cd429715c0d" => :yosemite
    sha256 "95cad8538d94472e8b1f889b91a1b8e22c1fc148b57303d0ab50112b2587ac33" => :x86_64_linux
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
