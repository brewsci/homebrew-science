class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btr509"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.6/bcftools-1.6.tar.bz2"
  sha256 "293010736b076cf684d2873928924fcc3d2c231a091084c2ac23a8045c7df982"

  bottle do
    sha256 "1ff54e0673300dd10e955f506c72d95d230977799156929b22c24889080b1401" => :sierra
    sha256 "27d79f1244ec79a028c9a8432def58ad906fc8ff3661c72f51d5d8d8808db11a" => :el_capitan
    sha256 "bba50d9490ae5f7b671ef24ee0bf11a41b858d0642aad31d644b4291fa4c94f6" => :yosemite
    sha256 "0dbef49ca15ddddccad18081db004c831f9c7c249eeff49792f06c4b17a2b359" => :x86_64_linux
  end

  option "with-gsl", "Enable polysomy command. Makes licence GPL3 not MIT/Expat."

  deprecated_option "with-polysomy" => "with-gsl"

  depends_on "htslib"
  depends_on "xz"
  depends_on "bzip2" unless OS.mac?
  depends_on "samtools" => :recommended
  depends_on "gsl" => :optional

  def install
    args = %W[--prefix=#{prefix} --with-htslib=#{Formula["htslib"].opt_prefix}]
    args << "--enable-libgsl" if build.with? "gsl"
    system "./configure", *args
    system "make"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    assert_match "number of SNPs:\t3", shell_output("#{bin}/bcftools stats #{pkgshare}/test/query.vcf")
    assert_match "fixploidy", shell_output("#{bin}/bcftools plugin -l")
  end
end
