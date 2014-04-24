require "formula"

class Prokka < Formula
  homepage "http://www.vicbioinformatics.com/software.prokka.shtml"
  #doi "10.1093/bioinformatics/btu153"
  version "1.8"
  url "http://www.vicbioinformatics.com/prokka-#{version}"
  sha1 "93758edf8c9702d6f4721139750f5c195af04b59"

  # The large database is distributed separately from the main script.
  resource "db" do
    url "http://www.vicbioinformatics.com/prokka-1.7.tar.gz"
    sha1 "a889d2f103a2305c0b2d8b504286023545959fbb"
  end

  depends_on "Bio::Perl" => :perl
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
    # Install the large database.
    resource("db").stage do
      rm "bin/prokka"
      prefix.install Dir["*"]
    end

    bin.install "prokka-#{version}" => "prokka"
  end

  test do
    system "#{bin}/prokka --version"
  end
end
