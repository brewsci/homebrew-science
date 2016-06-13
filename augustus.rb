class Augustus < Formula
  desc "predict genes in eukaryotic genomic sequences"
  homepage "http://bioinf.uni-greifswald.de/augustus/"
  # doi "10.1093/nar/gkh379"
  # tag "bioinformatics"

  url "http://bioinf.uni-greifswald.de/augustus/binaries/augustus-3.2.2.tar.gz"
  mirror "http://bioinf.uni-greifswald.de/augustus/binaries/old/augustus-3.2.2.tar.gz"
  sha256 "bb36fcaaaab32920908e794d04e6cb57a0c61d689bfbd31b9b6315233ea3559e"

  bottle do
    sha256 "f4b7001d5e3c215996686a3db9dad4cbe00244bd160d2d88c78295a9ffbad04c" => :el_capitan
    sha256 "a71a1833f5cffa81ecc2241b880cd18619ebf34b011d1c9223aed25dc3eff219" => :yosemite
    sha256 "8c3db1a79fc05a63af6f137aef3e2b7b00e5205a069d2fa679763496f323bd48" => :mavericks
    sha256 "c02c14202175281098ecb92304d6385755dbdb2b3dc9bd7b14920bcbaf367833" => :x86_64_linux
  end

  option "with-cgp",  "Enable comparative gene prediction"

  depends_on "bamtools"
  depends_on "boost"

  if build.with? "cgp"
    depends_on "gsl"
    depends_on "lp_solve"
    depends_on "suite-sparse"
  end

  def install
    args = []
    args << "COMPGENEPRED=true" if build.with? "cgp"

    system "make", "-C", "auxprogs/filterBam/src", "BAMTOOLS=#{Formula["bamtools"].opt_include}/bamtools", *args
    system "make", "INCLUDES=#{Formula["bamtools"].opt_include}/bamtools", *args

    rm_r %w[include src]
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  def caveats; <<-EOS.undent
    Set the environment variable AUGUSTUS_CONFIG_PATH:
      export AUGUSTUS_CONFIG_PATH=#{opt_prefix}/libexec/config
    EOS
  end

  test do
    system "#{bin}/augustus", "--version"
  end
end
