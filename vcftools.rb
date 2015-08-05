class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  # doi "10.1093/bioinformatics/btr330"
  # tag "bioinformatics"

  url "https://github.com/vcftools/vcftools/archive/v0.1.13.tar.gz"
  sha256 "0e241da57bc7048161d3751a1be842ad36e6a43f803c91cc9ef18aa15b3fc85e"

  head "https://github.com/vcftools/vcftools.git"

  bottle do
    cellar :any
    sha256 "3628fc7a18c01c578881757b7ec4564345a175f77adbdc634a63c4130bfb1afa" => :yosemite
    sha256 "52bf2fb95c8abf3db5214861a18b4c1f33f798e7cce3eb33e3ae866909d5be07" => :mavericks
    sha256 "a43af6012444b87cfc525aa31097814a35316c9c54dd1cc2752715da8b328f14" => :mountain_lion
  end

  depends_on "homebrew/dupes/zlib" => :optional

  def install
    args = %W[PREFIX=#{prefix} CPP=#{ENV.cxx}]

    if build.with? "zlib"
      zlib = Formula["zlib"]
      args << "LIB=-lz -L#{zlib.opt_lib} -I#{zlib.opt_include}"
    end

    system "make", "install", *args

    # Fix Non-executables were installed to bin
    (share/"man").install bin/"man1"
  end

  def caveats; <<-EOS.undent
    To use the Perl modules, make sure Vcf.pm, VcfStats.pm, and FaSlice.pm
    are included in your PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    system "#{bin}/vcftools"
  end
end
