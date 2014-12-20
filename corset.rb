require "formula"

class Corset < Formula
  homepage "https://code.google.com/p/corset-project/"
  #doi "10.1186/s13059-014-0410-6"

  url "https://docs.google.com/uc?export=download&id=0B1FwZagazjpcV0luTDZteHNPWXc"
  version "1.02"
  sha1 "ec75b183ff5e23394507477999f42d3f35311f59"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "ec576f2bd5c521a7f0ddee7b0f47cd4ea1161eca" => :yosemite
    sha1 "3d9311c1aa3e3f17e44f51767053e782ce630caf" => :mavericks
    sha1 "76a097d3c2b89b1b7cbcac2ead6d9d29554e9c7a" => :mountain_lion
  end

  depends_on "samtools-0.1"

  def install
    ENV.libcxx if MacOS.version < :mavericks

    system "./configure",
      "--prefix=#{prefix}",
      "--with-bam_inc=#{Formula["samtools-0.1"].opt_include}/bam",
      "--with-bam_lib=#{Formula["samtools-0.1"].opt_lib}"

    system "make"

    bin.install "corset"
    bin.install "corset_fasta_ID_changer"
  end

  test do
    system "corset | grep 'Corset Version #{version}'"
  end
end
