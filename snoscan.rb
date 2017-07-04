class Snoscan < Formula
  desc "Search for C/D box methylation guide snoRNA genes in a genomic sequence"
  homepage "http://lowelab.ucsc.edu/snoscan/"
  url "http://lowelab.ucsc.edu/software/snoscan-0.9.1.tar.gz"
  sha256 "e6ad2f10354cb0c4c44d46d5f298476dbe250a4817afcc8d1c56d252e08ae19e"
  # doi "10.1126/science.283.5405.1168"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "6db7af668b22f48aae3ad76945913edc404c93b0513e2eac670ddcaed10f85be" => :sierra
    sha256 "61bbcee065226ced533005e346b4cabcd23597afc8214ebb44490463f818dee2" => :el_capitan
    sha256 "6cabb0cba884b48146f385dea95d930638c4e9bbe50544d90b453511d970a2cc" => :yosemite
    sha256 "4fcc1753681dc38bbd49a1c639e11be576309e595aec59e3531229eb873c0f07" => :x86_64_linux
  end

  def install
    # Delete 0 byte sized files delivered by the archive
    # These files seem only to be problematic on mac OS
    if OS.mac?
      rm "snoscan"
      rm "search.o"
      rm "snoscan_main.o"
    end

    inreplace "sort-snos" do |s|
      s.sub! "#! /usr/local/bin/perl", "#!/usr/bin/perl"
    end

    system "make", "-C", "squid-1.5.11"
    system "make"
    bin.install "snoscan", "sort-snos"
    doc.install "COPYING", "GNULICENSE", "README"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/snoscan -h")
    assert_match "Usage", shell_output("#{bin}/sort-snos 2>&1", 255)
  end
end
