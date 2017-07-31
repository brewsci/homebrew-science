class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  # doi "10.1093/bioinformatics/btr330"
  # tag "bioinformatics"

  url "https://github.com/vcftools/vcftools/archive/v0.1.15.tar.gz"
  sha256 "bfbc50d92262868802d62f595c076b34f8e61a5ecaf48682328dad19defd3e7d"
  revision 1
  head "https://github.com/vcftools/vcftools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "be9efb8069e9c6ccb51c801b4dafc6923e3777695659b663e335475bc712e2df" => :sierra
    sha256 "de65f10ce8f5574193cac8295927d13922b0761763e20797abd713ebd2be802f" => :el_capitan
    sha256 "59bfcde67266b47a95dadf2a1f2c326dbe1ff725f30cbc59349f862c73dafe4f" => :yosemite
    sha256 "3424aeb62ff413a24d35908b7fc1e3ee6a6f891db3ed71b384a503151c79cc54" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib" => :run
  depends_on "zlib" => :optional if OS.mac?
  depends_on "zlib" if OS.linux?

  def install
    args = ["--prefix=#{prefix}", "--with-pmdir=lib/perl5/site_perl"]

    if build.with? ("zlib" || OS.linux?)
      zlib = Formula["zlib"]
      args << "LIB=-lz -L#{zlib.opt_lib} -I#{zlib.opt_include}"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", :PERL5LIB => lib/"perl5/site_perl")
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
