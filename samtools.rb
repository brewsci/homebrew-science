class Samtools < Formula
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/archive/1.2.tar.gz"
  sha256 "e4be60ad24fe0324b9384fe58ec2ab7359fe926fbee3115d869c447eb01a9e47"

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
    if build.without? "curses"
      ohai "Building without curses"
      inreplace "Makefile" do |s|
        s.gsub! "-D_CURSES_LIB=1", "-D_CURSES_LIB=0"
        s.gsub! "-lcurses", "# -lcurses"
      end
    end

    inreplace "Makefile", "include $(HTSDIR)/htslib.mk", ""
    htslib = Formula["htslib"].opt_prefix
    system "make", "HTSDIR=#{htslib}/include", "HTSLIB=#{htslib}/lib/libhts.a"

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
