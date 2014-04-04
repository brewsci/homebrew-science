require 'formula'

class Maker < Formula
  homepage 'http://www.yandell-lab.org/software/maker.html'
  #doi '10.1101/gr.6743907' => 'MAKER', '10.1104/pp.113.230144' => 'MAKER-P'
  url 'http://yandell.topaz.genetics.utah.edu/maker_downloads/static/maker-2.31.tgz'
  sha1 'b90176010de9fcaf643c988e6c78b311a445ceab'

  depends_on 'augustus' => :recommended
  depends_on 'blast'
  depends_on 'exonerate'
  depends_on 'infernal' => :optional
  depends_on :mpi => :optional
  depends_on 'repeatmasker'
  depends_on 'snap'
  depends_on 'trnascan' => :optional

  depends_on 'Bio::Perl' => :perl
  depends_on 'Bit::Vector' => :perl
  depends_on 'DBD::SQLite' => :perl
  depends_on 'DBI' => :perl
  depends_on 'File::Which' => :perl
  depends_on 'IO::All' => :perl
  depends_on 'IO::Prompt' => :perl
  depends_on 'Inline' => :perl
  depends_on 'Perl::Unsafe::Signals' => :perl
  depends_on 'PerlIO::gzip' => :perl
  depends_on 'forks' => :perl
  depends_on 'forks::shared' => :perl

  def install
    cd 'src' do
      system 'yes "" |perl Build.PL'
      system *%w[./Build install]
    end
    libexec.install Dir['*']
    bin.install_symlink '../libexec/bin/maker'
  end

  def caveats; <<-EOS.undent
    Optional components of MAKER
    1. Augustus 2.0 or higher. Download from http://bioinf.uni-greifswald.de/augustus/
    2. GeneMark-ES. Download from http://exon.biology.gatech.edu
    3. FGENESH 2.4 or higher. Purchase from http://www.softberry.com
    4. GeneMarkS. Download from http://exon.biology.gatech.edu
    EOS
  end

  test do
    system 'maker --version'
  end
end
