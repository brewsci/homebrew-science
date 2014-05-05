require "formula"

class Snoscan < Formula
  homepage "http://lowelab.ucsc.edu/snoscan/"
  #doi "10.1126/science.283.5405.1168"
  url "http://lowelab.ucsc.edu/software/snoscan.tar.gz"
  sha1 "a70fee3d72f83f548807f7da5c01ba3a692dd699"
  version "0.9b"

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
    system "#{bin}/snoscan -h"
    system "#{bin}/sort-snos 2>&1 |grep sort-snos"
  end
end
