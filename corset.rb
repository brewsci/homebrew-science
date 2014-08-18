require "formula"

class Corset < Formula
  homepage "https://code.google.com/p/corset-project/"
  #doi "10.1186/s13059-014-0410-6"

  url "https://docs.google.com/uc?export=download&id=0B1FwZagazjpcV0luTDZteHNPWXc"
  version "1.02"
  sha1 "ec75b183ff5e23394507477999f42d3f35311f59"

  depends_on "samtools"

  def install
    system "./configure",
      "--prefix=#{prefix}",
      "--with-bam_inc=#{Formula["samtools"].opt_include}/bam",
      "--with-bam_lib=#{Formula["samtools"].opt_lib}"

    system "make"

    bin.install "corset"
    bin.install "corset_fasta_ID_changer"
  end

  test do
    system "corset | grep 'Corset Version #{version}'"
  end
end
