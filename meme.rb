class Meme < Formula
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  # tag "bioinformatics"
  # doi "10.1093/nar/gkp335"

  url "http://meme-suite.org/meme-software/4.11.2/meme_4.11.2_2.tar.gz"
  version "4.11.2.2"
  sha256 "377238c2a9dda64e01ffae8ecdbc1492c100df9b0f84132d50c1cf2f68921b22"
  revision 1

  bottle do
    sha256 "dafc3dde034a0cffd6ee7070949cbb07070c1bb2c5c2266154fdc307198d821e" => :sierra
    sha256 "32ad789bca24589f6573215a3fe897a83c48a9e55601e1b722c64adaa6ff3b4e" => :el_capitan
    sha256 "29813728af994953e6435eb5764fff22fd427629cc97064b3544191badd77f9b" => :yosemite
    sha256 "63abc832e22073b7182ee205cd97466339dff9bfd07ee88fe2537f80c79af04c" => :x86_64_linux
  end

  keg_only <<-EOF.undent
    MEME installs many commands, and some conflict
    with other packages
  EOF

  depends_on :mpi => [:recommended]

  def install
    ENV.deparallelize
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    system "./configure", *args
    system "make", "install"
    doc.install "tests"
    perl_files = `grep -l -w "#!/usr/bin/perl" #{bin}/*`.split("\n")
    perl_files.each do |file|
      inreplace file, %r{^#!/usr/bin/perl.*}, "#!/usr/bin/env perl"
    end
  end

  test do
    system bin/"meme", doc/"tests/common/At.s"
  end
end
