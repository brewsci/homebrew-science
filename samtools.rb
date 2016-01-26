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
    sha256 "204cb532a9612dc2e060a6d3842eaa4275d8410275cb0944dce81d7a37efff7d" => :yosemite
    sha256 "661eb8b54e8c7856a53b34b8e3af9b23de7de0395c8f400fd940b9798bb2593f" => :mavericks
    sha256 "da29464e9605bf34349802f16a8237fc9f700f28c98432bb014c166d698e89b2" => :mountain_lion
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
