class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  # doi "10.1093/bioinformatics/btr330"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/vcftools/vcftools_0.1.12b.tar.gz"
  sha256 "9d2324512e9f1237d5cece74ba63965eb43643e9eada8685afe8217760a20a91"

  head "https://github.com/vcftools/vcftools.git"

  depends_on "homebrew/dupes/zlib" => :optional

  def install
    args = %W[PREFIX=#{prefix} CPP=#{ENV.cxx}]

    if build.with? "zlib"
      zlib = Formula["zlib"]
      args << "LIB=-lz -L#{zlib.opt_lib} -I#{zlib.opt_include}"
    end

    system "make", "install", *args
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
