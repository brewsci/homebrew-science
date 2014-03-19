require "formula"

class Prokka < Formula
  homepage "http://www.vicbioinformatics.com/software.prokka.shtml"
  version "1.8"
  url "http://www.vicbioinformatics.com/prokka-#{version}"
  sha1 "93758edf8c9702d6f4721139750f5c195af04b59"

  depends_on "Bio::Perl" => :perl
  depends_on "blast"
  depends_on "hmmer"
  depends_on "aragorn"
  depends_on "prodigal"
  depends_on "tbl2asn"
  depends_on "parallel"

  depends_on "infernal" => :recommended # for --rfam / non-coding RNA predictions

  # These optional dependencies have no formulae.
=begin
  depends_on "barrnap" => :recommended # fast rRNA searching using NHMMER
  depends_on "minced" => :recommended # find CRISPRs
  depends_on "rnammer" => :optional # requires patch to ensure it uses older HMMer 2.x
  depends_on "signalp" => :optional # for --gram / sig_peptide predictions
=end

  def install
    bin.install "prokka-#{version}" => "prokka"
  end

  def caveats; <<-EOS.undent
    Prokka requires a large database, which can be downloaded here:
    http://www.vicbioinformatics.com/software.prokka.shtml
    EOS
  end

  test do
    system "#{bin}/prokka --version"
  end
end
