class Samtools01 < Formula
  homepage "http://samtools.sourceforge.net/"
  # doi "10.1093/bioinformatics/btp352"
  # tag "bioinformatics"

  url "https://github.com/samtools/samtools/archive/0.1.20.tar.gz"
  sha256 "500019b4d1886ad995513d5ce8b413b14b51f16f251ce76bc0b35a446b182a47"

  bottle do
    cellar :any
    sha256 "acd7f43c7c12af030a02831aaead36711a41a4bda60fe4a406020b72e77cec3a" => :yosemite
    sha256 "fffd6868c552e316ae0055d9a695aea5107a5303e88f313360c34ef11ef40097" => :mavericks
    sha256 "8238ae7e31e946ac98c259fccdecdcd929368257f4c174e8b17938a9f6e9d7a9" => :mountain_lion
    sha256 "f23f37c4afe69f7516cd3d1630ec50478e651bdc29ef5cefe1ee910d3575e308" => :x86_64_linux
  end

  option "with-dwgsim", "Build with 'Whole Genome Simulation'"
  option "without-bcftools", "Do not install BCFtools"

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  conflicts_with "samtools"
  conflicts_with "bcftools"

  resource "dwgsim" do
    # http://sourceforge.net/apps/mediawiki/dnaa/index.php?title=Whole_Genome_Simulation
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
