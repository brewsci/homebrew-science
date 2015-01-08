class Quorum < Formula
  homepage "http://www.genome.umd.edu/quorum.html"
  #doi "arXiv:1307.3515"
  #tag "bioinformatics"

  url "ftp://ftp.genome.umd.edu/pub/QuorUM/quorum-1.0.0.tar.gz"
  sha1 "fc4ea191237f5738f563027f4e158980046e188d"

  depends_on "jellyfish"
  depends_on "pkg-config" => :build

  fails_with :clang do
    build 600
    cause "error: 'ext/stdio_filebuf.h' file not found"
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/quorum", "--version"
  end
end
