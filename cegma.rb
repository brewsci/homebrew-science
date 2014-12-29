require "formula"

class Cegma < Formula
  homepage "http://korflab.ucdavis.edu/datasets/cegma/"
  #doi "10.1093/bioinformatics/btm071"
  #tag "bioinformatics"

  url "http://korflab.ucdavis.edu/datasets/cegma/cegma_v2.4.010312.tar.gz"
  sha1 "4c046fe0376d69f6969a32af3481c60088306b9b"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "05109e3eb93ebe55011ffa94350082a4b7894e8c" => :yosemite
    sha1 "eee84e57db04c733be24fe0e910828fc861b60c4" => :mavericks
    sha1 "0db56c758491ba137490d0d45afcd82a3e17602e" => :mountain_lion
  end

  depends_on "blast"
  depends_on "geneid"
  depends_on "genewise"
  depends_on "hmmer"

  def install
    system "make"
    mkdir_p libexec/"bin"
    system "make", "install", "INSTALLDIR=#{libexec/"bin"}"
    (lib/"perl5/site_perl").install Dir["lib/*.pm"]
    libexec.install "data"
    doc.install "README"
    bin.install_symlink "../libexec/bin/cegma"
  end

  def caveats; <<-EOS.undent
    To use CEGMA, set the following environment variables:
      export CEGMA=#{HOMEBREW_PREFIX}/opt/cegma/libexec
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    system "#{bin}/cegma --help 2>&1 |grep -q cegma"
  end
end
