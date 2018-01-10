class Corset < Formula
  desc "Clusters de novo assembled transcripts and counts overlapping reads"
  homepage "https://github.com/Oshlack/Corset/wiki"
  # doi "10.1186/s13059-014-0410-6"
  # tag "bioinformatics"

  url "https://github.com/Oshlack/Corset/archive/version-1.05.tar.gz"
  sha256 "a4902035ad58e9a5896fe1951de83c3d6b64759919589ecc27cf714c6acfc487"

  bottle do
    cellar :any_skip_relocation
    sha256 "67000ee4879523d782b8a57ec94772a863dae25fd6c29fe573cfc9c1be5c8be1" => :el_capitan
    sha256 "ee530d4840361f257f7206097d995c04fa8745348e1999628582b9d54b86c80f" => :yosemite
    sha256 "f6a43255fa86b7cb67ddd6abd614f05c349a3043225f81cfed1edfeae99ae818" => :mavericks
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
