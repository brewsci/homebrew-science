class Weblogo < Formula
  homepage "http://weblogo.berkeley.edu/"
  # doi "10.1101/gr.849004"
  # tag "bioinformatics"

  url "http://weblogo.berkeley.edu/release/weblogo.2.8.2.tar.gz"
  sha256 "2d3e0040c0c1e363c1dfd57f8b585387eb682ed08b2cc2fe2e4cc2a33ac52266"

  bottle do
    cellar :any
    rebuild 1
    sha256 "267edf2808b1d8dd8248b8c5d0696c703e92478d7c08f799272e3a6c290a2e50" => :yosemite
    sha256 "927f1ca59e1bc45ac75759480b12bf0bb57864be5f0e2998cf6eb7739061efcd" => :mavericks
    sha256 "7a9a5e874106d63aeaafacba7e31b767d5c95a738ba628c953ba5d90e1b3f6b6" => :mountain_lion
    sha256 "0795bd6424589c43c029ea047e54d21c24384d916b862b273d5ae5c684b6f5ab" => :x86_64_linux
  end

  depends_on "imagemagick"
  depends_on "ghostscript"
  depends_on "Getopt::Std" => :perl

  def install
    # this only installs the command line tool, not the CGI web scripts
    inreplace "seqlogo", "/usr/bin/perl -w", "/usr/bin/env perl"
    inreplace "seqlogo", 'use lib "$Bin"', "use warnings; use lib '#{share}/weblogo'"
    bin.install "seqlogo"
    pkgshare.install "logo.pm", "template.pm"
    doc.install %w[README LICENSE Crooks-2004-GR-WebLogo.pdf]
  end

  test do
    assert_match "Shrink factor", shell_output("seqlogo -h 2>&1", 255)
  end
end
