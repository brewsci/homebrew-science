class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.janelia.org"
  # doi "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"

  url "http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "6ebacf56ceb47a16d71d49ffcf25e3cb46b8bd47c690cedbaa71dee709290703" => :yosemite
    sha256 "787e19eb2d8e648df3e2717d30a726bd1e58556c95c9417a59e268e0face2e5a" => :mavericks
    sha256 "d0ce08d257b38f4188f6d49e67c947a73044150e0e878d52b839f320d6ef4e65" => :mountain_lion
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
