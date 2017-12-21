class Bcftools < Formula
  desc "Tools for BCF/VCF files and variant calling from samtools"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btr509"
  # tag "bioinformatics"

  url "https://github.com/samtools/bcftools/releases/download/1.6/bcftools-1.6.tar.bz2"
  sha256 "293010736b076cf684d2873928924fcc3d2c231a091084c2ac23a8045c7df982"

  bottle do
    sha256 "48ac850690ea1c1bda9b4c5e23b46e162328438f145b229af4c7c79d2cc0f369" => :high_sierra
    sha256 "d46ac4024e70fcc2f376774cef371317a1e6a6027fb1cf6e7b0a22f22a6df4c8" => :sierra
    sha256 "9b52c234626d14512cbbff82b92106235fe8a75a311adc5715bae4e228851fc1" => :el_capitan
  end

  depends_on "gsl"
  depends_on "htslib"
  depends_on "xz"
  depends_on "bzip2" unless OS.mac?

  def install
    # Bug reported upstream and fixed in the next release.
    # https://github.com/samtools/bcftools/issues/684
    inreplace "Makefile",
      "PLUGIN_FLAGS = -bundle -bundle_loader bcftools",
      "PLUGIN_FLAGS = -bundle -bundle_loader bcftools -Wl,-undefined,dynamic_lookup"

    system "./configure",
      "--prefix=#{prefix}",
      "--with-htslib=#{Formula["htslib"].opt_prefix}",
      "--enable-libgsl"

    # Fix install: cannot stat ‘bcftools’: No such file or directory
    # Reported upstream: https://github.com/samtools/bcftools/issues/727
    system "make"

    system "make", "install"

    # For brew test bcftools
    pkgshare.install "test/query.vcf"
  end

  test do
    assert_match "number of SNPs:\t3", shell_output("#{bin}/bcftools stats #{pkgshare}/query.vcf")
    assert_match "fixploidy", shell_output("#{bin}/bcftools plugin -l")
  end
end
