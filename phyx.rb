class Phyx < Formula
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v0.99.tar.gz"
  sha256 "6c767b2b2a9666849c3035e479a2135734fccf882d4957f69ea251632d7ed010"
  revision 1
  head "https://github.com/FePhyFoFum/phyx.git"

  bottle do
    cellar :any
    sha256 "328cd6df7545795c70f1e33cfd5fd8ff5449cabfedd0e44f02c8ecc9637edee9" => :sierra
    sha256 "e333c9a1994e15fe74c66f5d0e4a624c854f15a073c03333422075ed2a23e375" => :el_capitan
    sha256 "b0c2413bb9807240c8a5f2fbe1bd1970f48adc0429b6ff89906e39c18fffd593" => :yosemite
    sha256 "b868b45bd947c354501753fec93751c2b68012b8dbf5767315bbe14062416a4e" => :x86_64_linux
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
