class Cdsclient < Formula
  desc "Tools for querying CDS databases"
  homepage "http://cdsarc.u-strasbg.fr/doc/cdsclient.html"
  url "http://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-3.84.tar.gz"
  sha256 "09eb633011461b9261b923e1d0db69d3591d376b447f316eb1994aaea8919700"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-science"
    sha256 cellar: :any_skip_relocation, high_sierra:  "6fca214528e4dddcb72a8e76d2886dbbb1bd768c0073ae1471dd44865d1d9a58"
    sha256 cellar: :any_skip_relocation, sierra:       "fba50ae2e39f40de30dcdd5f42f1d32b19b7ae7a360cfb9037edfdee01f29650"
    sha256 cellar: :any_skip_relocation, el_capitan:   "41aa43f0dbe94290c60ad47d4f6041cd4ffb0129e0ab45a43d9c1cde467213e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e657d3ed93174b22f63bf0b4b89bc265f7fa83cdddaef5c29b8fbbba2faca2f4"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man.mkpath
    system "make", "install", "MANDIR=#{man}"
    pkgshare.install bin/"abibcode.awk"
  end

  test do
    (testpath/"data").write <<~EOS
      12 34 12.5 -34 23 12
      13 24 57.1 +61 12 34
    EOS
    assert_match "#...upload ==>", pipe_output("#{bin}/findgsc - -r 5", testpath/"data", 0)
  end
end
