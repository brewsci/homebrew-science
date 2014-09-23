require 'formula'

class Samtools < Formula
  homepage 'http://samtools.sourceforge.net/'
  #doi '10.1093/bioinformatics/btp352'
  #tag "bioinformatics"
  head "https://github.com/samtools/samtools.git"

  url "https://github.com/samtools/samtools/archive/1.0.tar.gz"
  sha1 "78bdac301a2a342a2cfac100b79fb5fa99808114"

  option 'with-dwgsim', 'Build with "Whole Genome Simulation"'

  depends_on "htslib"

  resource 'dwgsim' do
    # http://sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation
    url 'https://downloads.sourceforge.net/project/dnaa/dwgsim/dwgsim-0.1.11.tar.gz'
    sha1 'e0275122618fa38dae815d2b43c4da87614c67dd'
  end

  def install
    inreplace "Makefile", "include $(HTSDIR)/htslib.mk", ""
    htslib = Formula["htslib"].opt_prefix
    system "make", "HTSDIR=#{htslib}/include", "HTSLIB=#{htslib}/lib/libhts.a"

    if build.with? 'dwgsim'
      ohai "Building dwgsim"
      samtools = pwd
      resource('dwgsim').stage do
        system "ln -s #{samtools} samtools"
        system "make", "CC=#{ENV.cc}"
        bin.install %w{dwgsim dwgsim_eval}
      end
    end

    bin.install 'samtools'
    bin.install %w{misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim}
    bin.install Dir['misc/*.pl']
    lib.install 'libbam.a'
    man1.install %w{samtools.1}
    (share+'samtools').install %w{examples}
    (include+'bam').install Dir['*.h']
  end

  test do
    system 'samtools 2>&1 |grep -q samtools'
  end
end
