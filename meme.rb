class Meme < Formula
  desc "Tools for motif discovery"
  homepage "http://meme-suite.org"
  # tag "bioinformatics"
  # doi "10.1093/nar/gkp335"

  url "http://meme-suite.org/meme-software/4.11.2/meme_4.11.2_2.tar.gz"
  version "4.11.2.2"
  sha256 "377238c2a9dda64e01ffae8ecdbc1492c100df9b0f84132d50c1cf2f68921b22"

  bottle do
    sha256 "68ffc928fd91c265161c603799acad20bdf59e191cba44c4fee693cb060913de" => :el_capitan
    sha256 "03738680e74d2983ca39f7c55af7ef5f0b10e150146d8eeb2298004dc3814376" => :yosemite
    sha256 "1f7c6057fd93c90f15bd0a66a0927c06eabd94f2d288179e2ff0bf1302fb248f" => :mavericks
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
