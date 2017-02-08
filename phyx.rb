class Phyx < Formula
  desc "Command-line tools for phylogenetic analyses"
  homepage "https://github.com/FePhyFoFum/phyx"
  url "https://github.com/FePhyFoFum/phyx/archive/v0.9.tar.gz"
  sha256 "99f467539e5289da3362fbd8a60c6ea16da33da4f050542eba422b794dd028f6"
  head "https://github.com/FePhyFoFum/phyx.git"
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
