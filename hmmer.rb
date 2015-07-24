class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.janelia.org"
  # doi "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"

  url "http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"

  bottle do
    cellar :any
    revision 2
    sha256 "763b5182ac642be5cf45334e801d35540c4d7db7bf8767791b652dcaed669c6b" => :yosemite
    sha256 "a3f95b4293f5dac713c558e40a6b0ebcad140234b8f03d2144c4b3625fd17271" => :mavericks
    sha256 "96ddaa4a6cedbb776bf94aeff38c102d5c5fd619e89056ba6d6fa645c946259f" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

  head do
    url "https://svn.janelia.org/eddylab/eddys/src/hmmer/trunk"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"

    # Installing libhmmer.a causes trouble for infernal.
    # See https://github.com/Homebrew/homebrew-science/issues/1931
    libexec.install lib/"libhmmer.a", include

    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/minifam")
  end
end
