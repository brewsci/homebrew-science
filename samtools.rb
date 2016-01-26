class Samtools < Formula
  desc "Tools (written in C using htslib) for manipulating next-generation sequencing data"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/releases/download/1.3/samtools-1.3.tar.bz2"
  sha256 "beea4003c795a0a25224656815b4036f6864b8753053ed30c590bb052b70b60e"

  head "https://github.com/samtools/samtools.git"

  bottle do
    cellar :any
    sha256 "c6bb8308c4ffb995ca46ac6be8e7087c22e7e2dd6bdb801690802b2d4f089a52" => :el_capitan
    sha256 "97447111d3ab5dce204761395afd600060ba36c8b47045a65a33b8efd10c4bb6" => :yosemite
    sha256 "c6baa6fc3f29cdb96a9fdf59f832455f4dd2c6ed25801d4a09f6e8cb9c810b98" => :mavericks
  end

  option "with-dwgsim", "Build with Whole Genome Simulation"
  option "without-curses", "Skip use of libcurses, for platforms without it, or different curses naming"

  depends_on "htslib"
  depends_on "dwgsim" => :optional

  def install
    htslib = Formula["htslib"].opt_prefix
    if build.without? "curses"
      ohai "Building without curses"
      system "./configure", "--with-htslib=#{htslib}", "--without-curses"
    else
      system "./configure", "--with-htslib=#{htslib}"
    end

    system "make"

    bin.install "samtools"
    bin.install %w[misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim]
    bin.install Dir["misc/*.pl"]
    lib.install "libbam.a"
    man1.install %w[samtools.1]
    (share+"samtools").install %w[examples]
    (include+"bam").install Dir["*.h"]
  end

  test do
    system "samtools 2>&1 |grep -q samtools"
  end
end
