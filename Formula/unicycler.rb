class Unicycler < Formula
  desc "Hybrid assembly pipeline for bacterial genomes"
  homepage "https://github.com/rrwick/Unicycler"
  url "https://github.com/rrwick/Unicycler/archive/v0.4.3.tar.gz"
  sha256 "ddd446f4fc17094825878ce245bb885e5b6dfe9b607d4a3e32387bf3fc1ea969"
  head "https://github.com/rrwick/Unicycler/releases"
  # doi "10.1371/journal.pcbi.1005595"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "5468027db8258aa6f836009bc8dc7520a686d3be66a61bae5fce173b06b6c7de" => :high_sierra
    sha256 "7ca3551f59a9ab6d7d703c2037448638b9ad856ed187e211245958a0795f295e" => :sierra
    sha256 "07f185841bb3c22682d1e9d34fe70cc4351b1ca5627aa7d36efa2a21e2738702" => :el_capitan
    sha256 "ee8897c79037c7b13305c47561affa4ebe8224be8cd334b1c8d5fbcbf825b607" => :x86_64_linux
  end

  needs :cxx14

  depends_on :python3
  depends_on "blast"
  depends_on "bowtie2"
  depends_on "pilon"
  depends_on "racon"
  depends_on "samtools"
  depends_on "spades"

  def install
    system "python3", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    assert_match "usage", shell_output("#{bin}/unicycler --help")
  end
end
