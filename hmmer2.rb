class Hmmer2 < Formula
  desc "Profiles protein sequences with hidden Markov models of a sequence family's consensus"
  homepage "http://hmmer.janelia.org/"
  # doi "10.1142/9781848165632_0019", "10.1186/1471-2105-11-431", "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"

  url "http://selab.janelia.org/software/hmmer/2.3.2/hmmer-2.3.2.tar.gz"
  sha256 "d20e1779fcdff34ab4e986ea74a6c4ac5c5f01da2993b14e92c94d2f076828b4"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "a7c3e09d523b973688399319cb3fd539cf69a050a3f64e4ab376e60684e231bb" => :yosemite
    sha256 "b17a9e698eea14f5b0f37b38d995c3e5cd63443218a92e453e210cf144cceff3" => :mavericks
    sha256 "cce31ff4bdf0b5e87654b38bf4219622ea906127f5b6b08561cc759d845a8d4c" => :mountain_lion
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
