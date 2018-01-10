class Meme < Formula
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  # tag "bioinformatics"
  # doi "10.1093/nar/gkp335"

  url "http://meme-suite.org/meme-software/4.11.2/meme_4.11.2_2.tar.gz"
  version "4.11.2.2"
  sha256 "377238c2a9dda64e01ffae8ecdbc1492c100df9b0f84132d50c1cf2f68921b22"
  revision 2

  bottle :disable, "needs to be rebuilt with latest open-mpi"

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
