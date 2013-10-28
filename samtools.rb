require 'formula'

class Dwgsim < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation'
  url 'http://downloads.sourceforge.net/project/dnaa/dwgsim/dwgsim-0.1.10.tar.gz'
  sha1 'f3127e84d54cdc52c9b5c988585358f69b4bb675'
end

class Samtools < Formula
  homepage 'http://samtools.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2'
  sha1 'ff3f4cf40612d4c2ad26e6fcbfa5f8af84cbe881'

  devel do
    version '0.2.0-rc3'
    url "https://github.com/samtools/samtools/archive/#{version}.tar.gz"
    sha1 '9e855ccfe08e0929923a120ed2dddc5c2cca2e35'
    depends_on 'htslib'
  end

  head 'https://github.com/samtools/samtools.git'

  option 'with-dwgsim', 'Build with "Whole Genome Simulation"'

  def install
    if build.devel?
      inreplace 'Makefile', 'include $(HTSDIR)/htslib.mk', ''
      htslib = Formula.factory('Htslib').opt_prefix
      system 'make', "HTSDIR=#{htslib}/include", "HTSLIB=#{htslib}/lib/libhts.a"
      system 'make', 'razip', "LDFLAGS=-L#{htslib}/lib", 'LDLIBS=-lhts -lz'
    else
      system 'make'
      system 'make', 'razip'
      system 'make', '-C', 'bcftools'
    end

    if build.include? 'with-dwgsim'
      ohai "Building dwgsim"
      samtools = pwd
      Dwgsim.new.brew do
        system "ln -s #{samtools} samtools"
        system "make"
        bin.install %w{dwgsim dwgsim_eval}
      end
    end

    bin.install %w{samtools razip}
    bin.install %w{bcftools/bcftools bcftools/vcfutils.pl} unless build.devel?
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
