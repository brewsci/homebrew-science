class Prokka < Formula
  homepage "http://www.vicbioinformatics.com/software.prokka.shtml"
  # doi "10.1093/bioinformatics/btu153"
  # tag "bioinformatics"
  url "http://www.vicbioinformatics.com/prokka-1.11.tar.gz"
  sha256 "ee18146c768fe6ac8e6c9e28bb35f686a5b79d5d5362c4b7665f6a33978101ae"

  head "https://github.com/tseemann/prokka.git"

  depends_on "Bio::Perl" => :perl
  depends_on "XML::Simple" => :perl
  depends_on "Time::Piece" => :perl if OS.linux?
  depends_on "blast"
  depends_on "infernal"
  depends_on "hmmer"
  depends_on "aragorn"
  depends_on "prodigal"
  depends_on "tbl2asn"
  depends_on "parallel"

  depends_on "barrnap" => :recommended # fast rRNA searching using NHMMER

  # These optional dependencies have no formulae.
  # depends_on "minced" => :recommended # find CRISPRs
  # depends_on "rnammer" => :optional # requires patch to ensure it uses older HMMer 2.x
  # depends_on "signalp" => :optional # for --gram / sig_peptide predictions

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/prokka --version"
  end
end
