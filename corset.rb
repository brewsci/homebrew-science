class Corset < Formula
  desc "Clusters de novo assembled transcripts and counts overlapping reads"
  homepage "https://github.com/Oshlack/Corset/wiki"
  # doi "10.1186/s13059-014-0410-6"
  # tag "bioinformatics"

  url "https://github.com/Oshlack/Corset/archive/version-1.05.tar.gz"
  sha256 "a4902035ad58e9a5896fe1951de83c3d6b64759919589ecc27cf714c6acfc487"

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
