class Samtools < Formula
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/archive/1.2.tar.gz"
  sha1 "9fabb4903b9d1521aeea8a5538e64aefe8e85526"

  head "https://github.com/samtools/samtools.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "de1ad3b2b528b175bdfcf0e78ac923da8187c7de" => :yosemite
    sha1 "37fca3fb8113838ae9178c2fc17043e9e3e42791" => :mavericks
    sha1 "e4d41de74cd32b2d88519e16f08abad025955582" => :mountain_lion
  end

  option "with-dwgsim", "Build with Whole Genome Simulation"
  option "without-curses", "Skip use of libcurses, for platforms without it, or different curses naming"

  depends_on "htslib"

  resource "dwgsim" do
    # http://sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation
    url "https://downloads.sourceforge.net/project/dnaa/dwgsim/dwgsim-0.1.11.tar.gz"
    sha1 "e0275122618fa38dae815d2b43c4da87614c67dd"
  end

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

    if build.with? "dwgsim"
      ohai "Building dwgsim"
      samtools = pwd
      resource("dwgsim").stage do
        ln_s samtools, "samtools"
        system "make", "CC=#{ENV.cc}"
        bin.install %w{dwgsim dwgsim_eval}
      end
    end

    bin.install "samtools"
    bin.install %w{misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim}
    bin.install Dir["misc/*.pl"]
    lib.install "libbam.a"
    man1.install %w{samtools.1}
    (share+"samtools").install %w{examples}
    (include+"bam").install Dir["*.h"]
  end

  test do
    system "samtools 2>&1 |grep -q samtools"
  end
end
