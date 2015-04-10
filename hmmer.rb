class Hmmer < Formula
  homepage "http://hmmer.janelia.org"
  # doi "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"
  url "http://selab.janelia.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "91c47db3e1fb729881d01b710b0f9ee9c138effe6184fbdffcb8f7a08706e43b" => :yosemite
    sha256 "1336dc5a1fa0952a3910e170bc1d25d601596f4c57793177ec5e001a1a26b74c" => :mavericks
    sha256 "cec39b2d2266736b52062879e4c87ff5b4fff106d7a96b6a0cf2b38bdfc501f4" => :mountain_lion
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

    share.install "tutorial"
  end

  test do
    system "#{bin}/hmmsearch", "-h"
  end
end
