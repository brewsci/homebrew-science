class Vsearch < Formula
  desc "USEARCH-compatible metagenomic sequence tool"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.3.4.tar.gz"
  sha256 "5411ab85179b090e4c56415744e0e432b2fdbce2889d8f7aafc2740f6b57d9f7"
  head "https://github.com/torognes/vsearch.git"
  # doi "10.5281/zenodo.31443"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "297ae30cc91288c0cd0dff91501ea6410f9e93678bb8fc4c9666e2c931abc398" => :sierra
    sha256 "4114a95029fc1e7e398e4bef838325f99e98bae3d85b004917c822eaa3197061" => :el_capitan
    sha256 "ab557fa500dcc49620d48b76c42a073d47605b2710bf0484aa3aab1a59ec7dc1" => :yosemite
    sha256 "c296eb55fc2114ac67fbaffbafee4e5b9c02604a002fd1caed3222b8d0052bd9" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "homebrew/dupes/zlib" unless OS.mac?
  depends_on "bzip2" unless OS.mac?

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "allpairs_global", shell_output("#{bin}/vsearch --help 2>&1")
  end
end
