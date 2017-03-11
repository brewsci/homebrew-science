class Vcftools < Formula
  desc "Tools for working with VCF files"
  homepage "https://vcftools.github.io/"
  # doi "10.1093/bioinformatics/btr330"
  # tag "bioinformatics"

  url "https://github.com/vcftools/vcftools/archive/v0.1.14.tar.gz"
  sha256 "ba440584645e9901c1eeb6b769ccd828591f0575c73349072cde3efa77da6fdf"

  head "https://github.com/vcftools/vcftools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc4ca5a97ad13c32a834e0bfcfc01f40a09f4802238435ebdc1efea80ef06fd1" => :sierra
    sha256 "1532aae5e450649328a8110ad22669c11a53551b41e03c1c0e7a14a427b8d37c" => :el_capitan
    sha256 "b381ea5c00f2f1e3d7284a8d37a7ae86bdc169225683b7af7196ac551c150bec" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib" => :run
  depends_on "homebrew/dupes/zlib" => :optional if OS.mac?
  depends_on "zlib" if OS.linux?

  def install
    args = ["--prefix=#{prefix}"]

    if build.with? "zlib" || OS.linux?
      zlib = Formula["zlib"]
      args << "LIB=-lz -L#{zlib.opt_lib} -I#{zlib.opt_include}"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
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
