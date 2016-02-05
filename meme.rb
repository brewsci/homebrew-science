class Meme < Formula
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  # tag "bioinformatics"
  # doi "10.1093/nar/gkp335"

  url "http://meme-suite.org/meme-software/4.10.1/meme_4.10.1_3.tar.gz"
  sha256 "9ccc0cfdb7d1467d5b021328fcf1407685d63fb6e65fa34b5b5929b493a35d66"
  version "4.10.1"
  revision 1

  bottle do
    sha256 "f2b74feb7f4b23ea69486a9a7b77aeb884fe1b6c37ac0ff1d214d99ec1a04a6d" => :el_capitan
    sha256 "9dd7b51a5c63ee4c254dab5d1a494c8af0483834361644727ad90e43ed625083" => :yosemite
    sha256 "9c9f6689114bdc801b5cb40399a21b5f4dddc80368440ab41e3fad010d16d430" => :mavericks
  end

  keg_only <<-EOF.undent
    MEME installs many commands, and some conflict
    with other packages.
  EOF

  depends_on :mpi => [:recommended]

  def install
    ENV.deparallelize
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    system "./configure", *args
    system "make", "install"
    doc.install "tests"
  end

  test do
    system bin/"meme", doc/"tests/At.s"
  end
end
