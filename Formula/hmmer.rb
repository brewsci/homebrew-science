class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.janelia.org"
  # doi "10.1371/journal.pcbi.1002195"
  # tag "bioinformatics"

  url "http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz"
  sha256 "dd16edf4385c1df072c9e2f58c16ee1872d855a018a2ee6894205277017b5536"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1bc2f9fb97eb3995a1f163f34d12e6450c4773ec6990ed10efefd79efeb6500f" => :el_capitan
    sha256 "223520bf7a648673730632698d93c28d652c32ac3134bb1f2cec3eb11cc16e16" => :yosemite
    sha256 "3b68fd88069ef6fc40fa58eb4b0bc230d442b936417a0ca841569675ab219372" => :mavericks
    sha256 "5585bed9532d2840056749e5ea353a57952ac75909681c0dc041518e3dfc17e3" => :x86_64_linux
  end

  head do
    url "https://svn.janelia.org/eddylab/eddys/src/hmmer/trunk"
    depends_on "autoconf" => :build
  end

  option "without-test", "Skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
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
