require 'formula'

class Samtools < Formula
  homepage 'http://samtools.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2'
  sha1 'ff3f4cf40612d4c2ad26e6fcbfa5f8af84cbe881'

  devel do
    version '0.2.0-rc6'
    url "https://github.com/samtools/samtools/archive/#{version}.tar.gz"
    sha1 '35118bcbcd7c438855d614d53ed5033b1944aea0'
    depends_on 'htslib'
  end

  head 'https://github.com/samtools/samtools.git'

  option 'with-dwgsim', 'Build with "Whole Genome Simulation"'
  option 'without-bcftools', 'Do not install bcftools'

  resource 'dwgsim' do
    # http://sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation
    url 'https://downloads.sourceforge.net/project/dnaa/dwgsim/dwgsim-0.1.11.tar.gz'
    sha1 'e0275122618fa38dae815d2b43c4da87614c67dd'
  end

  def install
    if build.devel? || build.head?
      inreplace 'Makefile', 'include $(HTSDIR)/htslib.mk', ''
      htslib = Formula["Htslib"].opt_prefix
      system 'make', "HTSDIR=#{htslib}/include", "HTSLIB=#{htslib}/lib/libhts.a"
      system 'make', 'razip', "LDFLAGS=-L#{htslib}/lib", 'LDLIBS=-lhts -lz'
    else
      system 'make'
      system 'make', 'razip'
      system 'make', '-C', 'bcftools' if build.with? 'bcftools'
    end

    if build.with? 'dwgsim'
      ohai "Building dwgsim"
      samtools = pwd
      resource('dwgsim').stage do
        system "ln -s #{samtools} samtools"
        system "make", "CC=#{ENV.cc}"
        bin.install %w{dwgsim dwgsim_eval}
      end
    end

    bin.install %w{samtools razip}
    bin.install 'bcftools/bcftools' unless build.devel? || build.head? || build.without?('bcftools')
    bin.install 'bcftools/vcfutils.pl' unless build.devel? || build.head?
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
