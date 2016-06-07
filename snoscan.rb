class Snoscan < Formula
  desc "Search for C/D box methylation guide snoRNA genes in a genomic sequence"
  homepage "http://lowelab.ucsc.edu/snoscan/"
  url "http://lowelab.ucsc.edu/software/snoscan-0.9.tar.gz"
  version "0.9b"
  sha256 "a73707f93bc52c3212fd2e7e339ca04d8b74aaa863fa417e26b4b935a6008756"
  # doi "10.1126/science.283.5405.1168"
  # tag "bioinformatics"

  def install
    inreplace "sort-snos" do |s|
      s.sub! "#! /usr/local/bin/perl", "#!/usr/bin/perl"
      s.sub! 'require ("getopts.pl");', "use Getopt::Std;"
      s.sub! "Getopts", "getopts"
    end

    # error: static declaration of 'getline' follows non-static declaration
    inreplace "squid-1.5j/sqio.c", "getline", "getline_ReadSeqVars"

    system *%W[make -C squid-1.5j]
    system "make"
    bin.install %W[snoscan sort-snos]
    doc.install %W[COPYING GNULICENSE README]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/snoscan -h")
    assert_match "Usage", shell_output("#{bin}/sort-snos 2>&1", 255)
  end
end
