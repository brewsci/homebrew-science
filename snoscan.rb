class Snoscan < Formula
  desc "Search for C/D box methylation guide snoRNA genes in a genomic sequence"
  homepage "http://lowelab.ucsc.edu/snoscan/"
  url "http://lowelab.ucsc.edu/software/snoscan-0.9.1.tar.gz"
  sha256 "e6ad2f10354cb0c4c44d46d5f298476dbe250a4817afcc8d1c56d252e08ae19e"
  # doi "10.1126/science.283.5405.1168"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "e672a0db29a37dc6830f97ce801353322f1c636feec22339517b6944dc89ce3c" => :el_capitan
    sha256 "a2de4c2ef29cd8345ea238739d8697705e064983cc38170103c4a83e1cf6069d" => :yosemite
    sha256 "490084d6547618269e875969702166703edd50f938ec06bda2efcf5444b63bae" => :mavericks
    sha256 "6cac0a87990be425756be08a80563e567f6e1478084449493fd6e00aed1c48d9" => :x86_64_linux
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
