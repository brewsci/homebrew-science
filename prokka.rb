require "formula"

class Prokka < Formula
  homepage "http://www.vicbioinformatics.com/software.prokka.shtml"
  #doi "10.1093/bioinformatics/btu153"
  url "http://www.vicbioinformatics.com/prokka-1.10.tar.gz"
  sha1 "46ece37d2d5c5ca2f3e740ffcdf9bdafaab92820"

  depends_on "Bio::Perl" => :perl
  depends_on "XML::Simple" => :perl
  depends_on "blast"
  depends_on "hmmer"
  depends_on "aragorn"
  depends_on "prodigal"
  depends_on "tbl2asn"
  depends_on "parallel"

  depends_on "barrnap" => :recommended # fast rRNA searching using NHMMER
  depends_on "infernal" => :recommended # for --rfam / non-coding RNA predictions

  # These optional dependencies have no formulae.
=begin
  depends_on "minced" => :recommended # find CRISPRs
  depends_on "rnammer" => :optional # requires patch to ensure it uses older HMMer 2.x
  depends_on "signalp" => :optional # for --gram / sig_peptide predictions
=end

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/prokka --version"
  end
end
