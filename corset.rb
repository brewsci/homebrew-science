class Corset < Formula
  homepage "https://code.google.com/p/corset-project/"
  #doi "10.1186/s13059-014-0410-6"
  #tag "bioinformatics"

  url "https://googledrive.com/host/0B1FwZagazjpcc0JLZWllcFlwUXc/corset-1.04.tar.gz"
  sha1 "730322d7b8c229a01edf7b0c0ad4acc11a014959"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "595de71a818accd8ba9ea1733919a2c1accb7f2a" => :yosemite
    sha1 "febb53baec4b65caed6bea4f73775207f390b0fe" => :mavericks
    sha1 "2e37f1e46e0c0e1e37b7180487759cfe2f719870" => :mountain_lion
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
