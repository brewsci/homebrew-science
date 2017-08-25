class Prokka < Formula
  desc "Rapid annotation of prokaryotic genomes"
  homepage "http://www.vicbioinformatics.com/software.prokka.shtml"

  url "https://github.com/tseemann/prokka/archive/v1.12.tar.gz"
  sha256 "845e46c9db167fb1fc9d16c934b7cfd89ddfeb6cd44bd8f42204ae7b4e87adba"
  revision 1

  head "https://github.com/tseemann/prokka.git"
  # doi "10.1093/bioinformatics/btu153"
  # tag "bioinformatics"

  depends_on "Bio::Perl" => :perl
  depends_on "XML::Simple" => :perl
  depends_on "Time::Piece" => :perl if OS.linux?

  depends_on "aragorn"
  depends_on "barrnap"
  depends_on "blast"
  depends_on "hmmer"
  depends_on "infernal"
  depends_on "minced"
  depends_on "parallel"
  depends_on "prodigal"
  depends_on "tbl2asn"

  depends_on "rnammer" => :optional

  def install
    # remove all bundled binaries and use Brew for dependencies
    rm_r "binaries"
    prefix.install Dir["*"]
  end

  def post_install
    system "#{bin}/prokka", "--setupdb"
  end

  test do
    assert_match "locustag", shell_output("#{bin}/prokka --help 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/prokka --version 2>&1")
    assert_match "Kingdoms:", shell_output("#{bin}/prokka --listdb 2>&1")
  end
end
