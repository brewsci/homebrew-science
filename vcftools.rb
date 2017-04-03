class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  # doi "10.1093/bioinformatics/btr330"
  # tag "bioinformatics"

  url "https://github.com/vcftools/vcftools/archive/v0.1.14.tar.gz"
  sha256 "ba440584645e9901c1eeb6b769ccd828591f0575c73349072cde3efa77da6fdf"
  revision 1

  head "https://github.com/vcftools/vcftools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4b6c7c42f4a4ae1b2ef3570c64ce00d128828a854651d7a31001b820fb2b2b2" => :sierra
    sha256 "3f172d6ecc7ef530e53d38238d18627ce96e4b9d53dec5bff9c52c7602d12040" => :el_capitan
    sha256 "938e1f243b1333f12a40fa2b423668a75785028bb4350b691680d14e7f27e259" => :yosemite
    sha256 "395b11bdf5c137f88a734abd2d7c06ea65bc563294acb09570ad302098c9b352" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib" => :run
  depends_on "zlib" => :optional if OS.mac?
  depends_on "zlib" if OS.linux?

  def install
    args = ["--prefix=#{prefix}", "--with-pmdir=#{lib}/perl5/site_perl"]

    if build.with? "zlib" || OS.linux?
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
