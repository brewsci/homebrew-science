class Corset < Formula
  homepage "https://code.google.com/p/corset-project/"
  #doi "10.1186/s13059-014-0410-6"
  #tag "bioinformatics"

  url "https://googledrive.com/host/0B1FwZagazjpcc0JLZWllcFlwUXc/corset-1.04.tar.gz"
  sha1 "730322d7b8c229a01edf7b0c0ad4acc11a014959"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ec576f2bd5c521a7f0ddee7b0f47cd4ea1161eca" => :yosemite
    sha1 "3d9311c1aa3e3f17e44f51767053e782ce630caf" => :mavericks
    sha1 "76a097d3c2b89b1b7cbcac2ead6d9d29554e9c7a" => :mountain_lion
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
