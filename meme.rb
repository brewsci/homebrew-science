class Meme < Formula
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  # tag "bioinformatics"
  # doi "10.1093/nar/gkp335"

  url "http://meme-suite.org/meme-software/4.11.2/meme_4.11.2_2.tar.gz"
  version "4.11.2.2"
  sha256 "377238c2a9dda64e01ffae8ecdbc1492c100df9b0f84132d50c1cf2f68921b22"

  bottle do
    sha256 "f7f0026b72349dd004a45e2058f608ad030d35c47db166f79f0cb160b928d693" => :sierra
    sha256 "2d77bc1f91f74773a3beb7c217a689ba0d32a0bb274eee16696855e0bb79c0e4" => :el_capitan
    sha256 "a7f07d62585ed569e6f7c26113b7f23afe1c14ac9f3bf8397bc057fa9a8176c9" => :yosemite
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
    system bin/"meme", doc/"tests/common/At.s"
  end
end
