class Meme < Formula
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  # tag "bioinformatics"
  # doi "10.1093/nar/gkp335"

  url "http://meme-suite.org/meme-software/4.10.1/meme_4.10.1_3.tar.gz"
  sha256 "9ccc0cfdb7d1467d5b021328fcf1407685d63fb6e65fa34b5b5929b493a35d66"
  version "4.10.1"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha256 "29400cf90467c47610fe940c4a083e1ecdc130c7f9003f9868c81768c39839f3" => :yosemite
    sha256 "f99df86939f31199bcae07306f1f628b2560a1c247c151692e6ab841532b262e" => :mavericks
    sha256 "d32ef25758ad84270ec2aaa817c96a7d9e1555eb4556a4fa2f6dd0dccc58408d" => :mountain_lion
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
