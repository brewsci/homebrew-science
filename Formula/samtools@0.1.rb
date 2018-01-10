class SamtoolsAT01 < Formula
  desc "Tools for manipulating next-generation sequencing data"
  homepage "https://samtools.sourceforge.io/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/archive/0.1.20.tar.gz"
  sha256 "500019b4d1886ad995513d5ce8b413b14b51f16f251ce76bc0b35a446b182a47"

  bottle do
    cellar :any_skip_relocation
    sha256 "94daeca01f8f12745a5e19eecd6fdf85e0202dd2dfdbfc999c9c57e591ab4f6b" => :sierra
    sha256 "5fb71541a4b39224489f36de9926fd1e95ae172b7a17eff0e11287861012ee4f" => :el_capitan
    sha256 "b9160636c1aca2857dca85da201ee92836792c7c2b9dae421b57331e359d8032" => :yosemite
    sha256 "5e937da595debfc4c709824ec58887649da96d69879c1903fd55dca342f7a198" => :x86_64_linux
  end

  keg_only :versioned_formula

  option "with-dwgsim", "Build with 'Whole Genome Simulation'"
  option "without-bcftools", "Do not install BCFtools"

  unless OS.mac?
    depends_on "ncurses"
    depends_on "zlib"
  end

  resource "dwgsim" do
    # https://web.archive.org/web/20140610040151/sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation
    url "https://downloads.sourceforge.net/project/dnaa/dwgsim/dwgsim-0.1.11.tar.gz"
    sha256 "6ffc8a4f7d20bc7c8b3efa1d2b3ae6cbf9609a93db976d4e7ccd2a209a2305b5"
  end

  def install
    system "make"
    system "make", "-C", "bcftools" if build.with? "bcftools"

    if build.with? "dwgsim"
      ohai "Building dwgsim"
      resource("dwgsim").stage do
        ln_s buildpath, "samtools"
        system "make", "CC=#{ENV.cc}"
        bin.install %w[dwgsim dwgsim_eval]
      end
    end

    bin.install %w[
      samtools bcftools/bcftools bcftools/vcfutils.pl
      misc/maq2sam-long misc/maq2sam-short misc/md5fa misc/md5sum-lite misc/wgsim
    ]

    bin.install Dir["misc/*.pl"]
    lib.install "libbam.a"
    man1.install "samtools.1"
    (share+"samtools").install "examples"
    (include+"bam").install Dir["*.h"]
  end

  test do
    assert_match "samtools", shell_output("#{bin}/samtools 2>&1", 1)
  end
end
