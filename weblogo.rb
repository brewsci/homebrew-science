class Weblogo < Formula
  homepage "http://weblogo.berkeley.edu/"
  # doi "10.1101/gr.849004"
  # tag "bioinformatics"

  url "http://weblogo.berkeley.edu/release/weblogo.2.8.2.tar.gz"
  sha256 "2d3e0040c0c1e363c1dfd57f8b585387eb682ed08b2cc2fe2e4cc2a33ac52266"

  depends_on "imagemagick"
  depends_on "ghostscript"
  depends_on "Getopt::Std" => :perl

  def install
    # this only installs the command line tool, not the CGI web scripts
    inreplace "seqlogo", "/usr/bin/perl -w", "/usr/bin/env perl"
    inreplace "seqlogo", 'use lib "$Bin"', "use warnings; use lib '#{share}'"
    bin.install "seqlogo"
    share.install "logo.pm", "template.pm"
    doc.install %w[README LICENSE Crooks-2004-GR-WebLogo.pdf]
  end

  test do
    assert_match "Shrink factor", shell_output("seqlogo -h 2>&1", 255)
  end
end
