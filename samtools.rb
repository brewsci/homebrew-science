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

  head 'https://github.com/samtools/samtools.git'

  option 'with-dwgsim', 'Build with "Whole Genome Simulation"'

  def install
    system "make"
    system "make razip"
    cd 'bcftools' do
      system "make"
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

    bin.install %w{samtools razip bcftools/bcftools bcftools/vcfutils.pl}
    bin.install %w{misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim}
    bin.install Dir['misc/*.pl']
    lib.install 'libbam.a'
    man1.install %w{samtools.1}
    (share+'samtools').install %w{examples}
    (include+'bam').install Dir['*.h']
  end
end
