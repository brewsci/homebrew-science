class Samtools01 < Formula
  homepage "http://samtools.sourceforge.net/"
  #doi "10.1093/bioinformatics/btp352"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2"
  sha1 "ff3f4cf40612d4c2ad26e6fcbfa5f8af84cbe881"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "233b4c802c5648ea70e8de7faa0d51be32786860" => :yosemite
    sha1 "a5d3ce8692e7e1e7067d2c6a942e456b6b731fec" => :mavericks
    sha1 "73c1d0bfd0462ff57c0354fa3870765a2df64737" => :mountain_lion
  end

  option "with-dwgsim", "Build with 'Whole Genome Simulation'"
  option "without-bcftools", "Do not install bcftools"

  conflicts_with "samtools"
  conflicts_with "bcftools"

  resource "dwgsim" do
    # http://sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation
    url "https://downloads.sourceforge.net/project/dnaa/dwgsim/dwgsim-0.1.11.tar.gz"
    sha1 "e0275122618fa38dae815d2b43c4da87614c67dd"
  end

  def install
    system "make"
    system "make", "-C", "bcftools" if build.with? "bcftools"

    if build.with? "dwgsim"
      ohai "Building dwgsim"
      samtools = pwd
      resource("dwgsim").stage do
        system "ln -s #{samtools} samtools"
        system "make", "CC=#{ENV.cc}"
        bin.install %w{dwgsim dwgsim_eval}
      end
    end

    bin.install %w{
      samtools bcftools/bcftools bcftools/vcfutils.pl
      misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim
    }

    bin.install Dir["misc/*.pl"]
    lib.install "libbam.a"
    man1.install %w{samtools.1}
    (share+"samtools").install %w{examples}
    (include+"bam").install Dir["*.h"]
  end

  test do
    system "#{bin}/samtools 2>&1 |grep -q samtools"
  end
end
