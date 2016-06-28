class Samtools < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2"
  sha256 "6c3d74355e9cf2d9b2e1460273285d154107659efa36a155704b1e4358b7d67e"
  head "https://github.com/samtools/samtools.git"

  bottle do
    cellar :any
    sha256 "c6bb8308c4ffb995ca46ac6be8e7087c22e7e2dd6bdb801690802b2d4f089a52" => :el_capitan
    sha256 "97447111d3ab5dce204761395afd600060ba36c8b47045a65a33b8efd10c4bb6" => :yosemite
    sha256 "c6baa6fc3f29cdb96a9fdf59f832455f4dd2c6ed25801d4a09f6e8cb9c810b98" => :mavericks
    sha256 "d0e3e6f7ffba8ed4005ff14155727292b939a645c8c2376191aae0f24cf20eb3" => :x86_64_linux
  end

  depends_on "htslib"
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  def install
    system "./configure", "--with-htslib=#{Formula["htslib"].opt_prefix}"
    system "make"

    bin.install Dir["{samtools,misc/*}"].select { |f| File.executable?(f) }
    lib.install "libbam.a"
    (include/"bam").install Dir["*.h"]
    man1.install "samtools.1"
    pkgshare.install "examples"
  end

  test do
    system bin/"samtools", "--help"
  end
end
