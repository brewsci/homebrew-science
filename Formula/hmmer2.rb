class Hmmer2 < Formula
  desc "Profiles protein sequences with hidden Markov models of a sequence family's consensus"
  homepage "http://hmmer.janelia.org/"
  # doi "10.1142/9781848165632_0019", "10.1186/1471-2105-11-431", "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"

  url "http://eddylab.org/software/hmmer/2.3.2/hmmer-2.3.2.tar.gz"
  sha256 "d20e1779fcdff34ab4e986ea74a6c4ac5c5f01da2993b14e92c94d2f076828b4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fea2319bdad10e37f6f0d52fcbd6706328c49f6ec28168463828e04a8deb3f7d" => :yosemite
    sha256 "0eba7cfb9ea8d0f8822dfbcc444931b40cb0339daef714cc7bd920dff8cbbdb1" => :mavericks
    sha256 "286f8cb2634e5a68c8836348665ba76af14cf76084fdb0f2084735d53a679467" => :mountain_lion
    sha256 "a9a224ff18ecbcbeb28721f03eb806f3300017d180f1fb8e17bca7f9d2ace277" => :x86_64_linux
  end

  keg_only "hmmer2 conflicts with hmmer version 3"

  def install
    # Fix "make: Nothing to be done for `install'."
    rm "INSTALL"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--enable-threads"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "threshold", shell_output("#{bin}/hmmpfam 2>&1", 1)
  end
end
