class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  # doi "10.1093/bioinformatics/btr330"
  # tag "bioinformatics"

  url "https://github.com/vcftools/vcftools/archive/v0.1.15.tar.gz"
  sha256 "bfbc50d92262868802d62f595c076b34f8e61a5ecaf48682328dad19defd3e7d"
  head "https://github.com/vcftools/vcftools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7a409660af5ccc477c42b3e2b334c1d27d7bfd82e5857c1e9e033b9a1e9c20e" => :sierra
    sha256 "1beb6162ac210ea24e5dc6edefac8319eec1a0a2f2ffd63aee0600b7d9e0db10" => :el_capitan
    sha256 "a3868607b7d24d4775d1dae4bb54aea2ec8006626322d5bf2a8f50e9e875d93f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib" => :run
  depends_on "zlib" => :optional if OS.mac?
  depends_on "zlib" if OS.linux?

  def install
    args = ["--prefix=#{prefix}", "--with-pmdir=#{lib}/perl5/site_perl"]

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
