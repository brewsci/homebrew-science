class Maker < Formula
  homepage "http://www.yandell-lab.org/software/maker.html"
  # doi '10.1101/gr.6743907' => 'MAKER', '10.1186/1471-2105-12-491' => 'MAKER2', '10.1104/pp.113.230144' => 'MAKER-P'
  # tag "bioinformatics"

  url "http://yandell.topaz.genetics.utah.edu/maker_downloads/static/maker-2.31.9.tgz"
  sha256 "c92f9c8c96c6e7528d0a119224f57cf5e74fadfc5fce5f4b711d0778995cabab"

  depends_on "augustus" => :optional
  depends_on "blast" => :recommended
  depends_on "exonerate" => :recommended
  depends_on "infernal" => :optional
  depends_on "mir-prefer" => :optional
  depends_on "open-mpi" => :optional
  depends_on "postgresql" => :optional
  depends_on "repeatmasker" => :recommended
  depends_on "snap" => :recommended
  depends_on "snoscan" => :optional
  depends_on "trnascan" => :optional
  # No formula: depends_on 'genemark-es' => :optional
  # No formula: depends_on 'genemarks' => :optional

  # Depends_on "Bio::Perl" => :perl
  # Depends_on "Bit::Vector" => :perl
  # Depends_on "DBD::SQLite" => :perl
  # Depends_on "DBI" => :perl
  # Depends_on "File::Which" => :perl
  # Depends_on "IO::All" => :perl
  # Depends_on "IO::Prompt" => :perl
  # Depends_on "Inline::C" => [:perl, "Inline"]
  # Depends_on "DBD::Pg" => :perl if build.with? "postgresql"
  # Depends_on "Perl::Unsafe::Signals" => :perl
  # Depends_on "PerlIO::gzip" => :perl
  # Depends_on "forks" => :perl
  # Depends_on "forks::shared" => :perl

  def install
    cd "src" do
      mpi = if build.with?("open-mpi") then "yes" else "no" end
      system "(echo #{mpi}; yes '') |perl Build.PL"
      system *%w[./Build install]
    end
    libexec.install Dir["*"]
    bin.install_symlink %w[
      ../libexec/bin/gff3_merge
      ../libexec/bin/maker]
  end

  def caveats; <<~EOS
    Optional components of MAKER
      GeneMarkS and GeneMark-ES. Download from http://exon.biology.gatech.edu
      FGENESH 2.4 or higher. Purchase from http://www.softberry.com

    MAKER is available for academic use under either the Artistic
    License 2.0 developed by the Perl Foundation or the GNU General
    Public License developed by the Free Software Foundation.

    MAKER is not available for commercial use without a license. Those
    wishing to license MAKER for commercial use should contact Beth
    Drees at the University of Utah TCO to discuss your needs.
    EOS
  end

  test do
    system "#{bin}/maker", "--version"
  end
end
