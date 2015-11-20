class Corset < Formula
  homepage "https://code.google.com/p/corset-project/"
  #doi "10.1186/s13059-014-0410-6"
  #tag "bioinformatics"

  url "https://googledrive.com/host/0B1FwZagazjpcc0JLZWllcFlwUXc/corset-1.04.tar.gz"
  sha1 "730322d7b8c229a01edf7b0c0ad4acc11a014959"

  bottle do
    cellar :any
    sha256 "977bc8dd872fedd86bc869f09d1d7262db98a424a239678e54f0744d058dfe0b" => :yosemite
    sha256 "70ee1716feec3c4510959d64c3a57f7a1b66c520cebeaa9b1af3c6ee91d94ae2" => :mavericks
    sha256 "0d9c81f718dc245992994db69d1584cac1f75827ee1c48b96fb06b79660e58e5" => :mountain_lion
  end

  depends_on "samtools"
  depends_on "htslib"

  def install
    ENV.libcxx if MacOS.version < :mavericks

    system "./configure",
      "--prefix=#{prefix}",
      "--with-bam_inc=#{Formula["samtools"].opt_include}/bam",
      "--with-bam_lib=#{Formula["samtools"].opt_lib}",
      "--with-htslib=#{Formula["htslib"].opt_lib}"

    system "make"

    bin.install "corset"
    bin.install "corset_fasta_ID_changer"
  end

  test do
    system "corset | grep 'Corset Version #{version}'"
  end
end
